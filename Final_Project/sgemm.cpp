#include "Halide.h"
#include <stdio.h>

using namespace Halide;

int main(int argc, char **argv) {
    ImageParam A(Int(8), 2, "A");
    ImageParam B(Int(8), 2, "B");

    Var i, j;
    RDom k(0, K*KK*KKK);

    Target target = get_host_target();
    target.set_feature(Target::Altera);

    Func C(Place::Device), A_loader(Place::Device), A_feeder(Place::Device), A_serializer(Place::Host),
         B_loader(Place::Device), B_feeder(Place::Device), B_serializer(Place::Host),
         C_drainer(Place::Device), C_collector(Place::Device), C_unloader(Place::Device), C_deserializer(Place::Host);
    C(j, i) = 0;
    C(j, i) += A(k, i) * B(j, k);

    Var ii, jj, iii, jjj;
    RDom kk(0, KK*KKK), kkk(0, KKK);
    C.tile(j, i, jj, ii, JJ*JJJ, II*III).tile(jj, ii, jjj, iii, JJJ, III);
    C.update(0)
     .tile(k, j, i, kk, jj, ii, KK*KKK, JJ*JJJ, II*III)
     .tile(kk, jj, ii, kkk, jjj, iii, KKK, JJJ, III);

    C.update(0).vread({A,B}); // vectorize A and B based on loop kkk

    C.update(0)  //
     .isolate_producer_chain(A, A_serializer, A_loader, A_feeder)
     .isolate_producer_chain(B, B_serializer, B_loader, B_feeder)
     .isolate_consumer_chain(C, C_drainer, C_collector, C_unloader, C_deserializer);

    A_serializer.sread().swrite();
    B_serializer.sread().swrite();
    C_collector.vwrite();
    C_unloader.vread().vwrite();

    A_serializer.reorder(kkk,ii,jjj,iii,kk,jj,k,j,i);
    A_loader.reorder    (kkk,ii,jjj,iii,kk,jj,k,j,i);
    A_feeder.reorder    (kkk,ii,jjj,iii,kk,jj,k,j,i);

    B_serializer.reorder(kkk,jjj,iii,jj,kk,ii,k,j,i);
    B_loader.reorder    (kkk,jjj,iii,jj,kk,ii,k,j,i);
    B_feeder.reorder    (kkk,jjj,iii,jj,kk,ii,k,j,i);

    C.update(0).unroll(ii).unroll(jj).forward(A_feeder, { 0, 1 }).forward(B_feeder, { 1, 0 });

    A_serializer.remove(jjj, jj, j);
    A_loader.remove(jjj, jj);
    A_feeder.buffer(iii, true).unroll(ii).scatter(A, { 1 });

    B_serializer.remove(iii, ii, i);
    B_loader.remove(iii, ii);
    B_feeder.buffer(jj, true).unroll(jj).scatter(B, { 1 });

    C.update(0).rotating_register();

    C_drainer.unroll(ii).unroll(jj).gather(C, jjj, { -1, 0 });
    C_collector.unroll(jj).gather(C_drainer, jjj, { -1 });

    C_unloader.reorder    (jj, ii, jjj, iii, j, i);
    C_deserializer.reorder(jj, ii, jjj, iii, j, i);

    C_deserializer.compile_jit(target);
    return 0;
}
