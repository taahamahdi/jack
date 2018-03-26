IMAGE = os.iso
BIN = kernel.bin
KERNOBJ = kernel/kernel.a
ARCHSRC = $(wildcard arch/*.s)
ARCHOBJS = $(ARCHSRC:.s=.o)

LIBK = libc/libk.a

LINKER = linker.ld

ISOFILES = isofiles
IMAGEPATH = isofiles/boot

GRUBMKRESCUE = grub-mkrescue

LD = ld
LD_FLAGS = -n

LIBKPATH = libc/
KERNPATH = kernel/
ARCHPATH = arch/

all : $(IMAGE)

$(IMAGE) : $(BIN)
	cp $(BIN) $(IMAGEPATH)
	$(GRUBMKRESCUE) -o $(IMAGE) $(ISOFILES)

$(BIN) : $(ARCHOBJS) $(KERNOBJ)
	$(LD) $(LD_FLAGS) -o $(BIN) -T $(LINKER) $(ARCHOBJS) $(KERNOBJ) $(LIBK)

$(ARCHOBJS) :
	cd $(ARCHPATH) && make

$(KERNOBJ) : $(LIBK) 
	cd $(KERNPATH) && make

$(LIBK) :
	cd $(LIBKPATH) && make

.PHONY: clean
clean:
	rm -f *.o
	rm -f $(IMAGEPATH)/$(BIN)x
	rm -f $(IMAGE)
	rm -f $(BIN)
	cd $(KERNPATH) && make clean
	cd $(ARCHPATH) && make clean
	cd $(LIBKPATH) && make clean