#include <cuda.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

//#define CHUNK_SIZE (2ULL * 1024 * 1024)
#define CHUNK_SIZE 4ULL

#define WAIT_TIME   10000000000L // about 5 seconds on RTX3080

__global__ void 
loop(volatile uint64_t *page, uint64_t x)
{
  uint64_t y = x;
  volatile uint64_t *ptr;
  uint64_t clk0;
  uint64_t clk1;
  
  while (y == x) {
    for (ptr = (uint64_t *)page[0]; ptr != page; ptr = (uint64_t *)ptr[0])
      ++ptr[2];
    
    clk0 = clock64();
    clk1 = 0;
    while (clk1 < WAIT_TIME)
      clk1 = clock64() - clk0;
    
    y = ptr[1];
  }
}

__global__ void
put(uint8_t *page, unsigned page_index, uint64_t value)
{
  page[page_index * 4096] = value;
}

void
access_page(uint8_t *page, unsigned page_index)
{
  put<<<1, 1>>>(page, page_index, 3);
  cudaDeviceSynchronize();
  printf("page %u is accessed by gpu\n", page_index);
  fflush(stdout);
}

int 
main(int argc, char *argv[])
{
  uint8_t *chunk = NULL;
  uint8_t *chunk1 = NULL;
  
  cudaDeviceReset();

  printf("cudaDeviceReset is called\n");
  fflush(stdout);
  while (getchar() != '\n') {}
  
  // hoard a large address space
  cudaMallocManaged(&chunk, CHUNK_SIZE);
  //cudaMalloc(&chunk, CHUNK_SIZE);
  printf("cudaMallocManaged is called, (chunk) addr: %p, size: %llx\n", chunk, CHUNK_SIZE);

  cudaMallocManaged(&chunk1, CHUNK_SIZE);
  //cudaMalloc(&chunk1, CHUNK_SIZE);
  printf("cudaMallocManaged is called, (chunk1) addr: %p, size: %llx\n", chunk1, CHUNK_SIZE);
  fflush(stdout);
  while (getchar() != '\n') {}


  memset(chunk, 0, CHUNK_SIZE);
  printf("accessed by cpu\n");

  fflush(stdout);
  while (getchar() != '\n') {}

  access_page(chunk, 0);
  printf("accessed by gpu\n");

  fflush(stdout);
  while (getchar() != '\n') {}

  memset(chunk, 0, CHUNK_SIZE);
  printf("accessed by cpu again\n");

  fflush(stdout);
  while (getchar() != '\n') {}
  /*
  while (1) {
      printf("input page index\n");
      scanf("%u", &page_index);

      access_page(chunk, page_index);
  }
  */

  
  cudaFree(chunk);
  cudaFree(chunk1);
}


