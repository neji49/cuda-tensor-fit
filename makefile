#Makefile to run and test fit tensor functions

CFLAGS = -g 

memcheck = valgrind --tool=memcheck --leak-check=yes --track-origins=yes 

leaks: test
	${memcheck} ./main_test

run-cuda: cuda-test
	./cuda_test

run-opt:opt-test
	./opt_test

run: test
	./main_test

cuda-test: fit_tensor_cuda.o
	gcc ${CFLAGS} -o cuda_test cuda_test.c fit_tensor_util.o fit_tensor_cuda.o -lgsl -lgslcblas -lm -lcunit

opt-test: fit_tensor_util.o
	gcc ${CFLAGS} -o opt_test opt_test.c fit_tensor_util.o -lgsl -lgslcblas -lm -lcunit

test: fit_tensor.o
	gcc ${CFLAGS} -o main_test fit_unit_test.c fit_tensor.o fit_tensor_util.o -lgsl -lgslcblas -lm -lcunit

fit_tensor_cuda.o: fit_tensor_util.o
	nvcc -c fit_tensor_cuda.cu

fit_tensor.o: fit_tensor_opt.c fit_tensor_util.o
	gcc ${CFLAGS} -o fit_tensor.o -c fit_tensor_opt.c

fit_tensor_util.o: fit_tensor_util.c
	gcc ${CFLAGS} -o fit_tensor_util.o -c fit_tensor_util.c

clean: 
	rm *.o
