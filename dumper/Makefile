INCLUDES := -I/usr/local/cuda/include
INCLUDES += -I/usr/src/nvidia-535.113.01/common/inc
INCLUDES += -I/usr/src/nvidia-535.113.01/nvidia
INCLUDES += -I/usr/src/nvidia-535.113.01/nvidia-uvm

all: 
	gcc $(INCLUDES) -o dumper dumper.c -lnvidia-ml

