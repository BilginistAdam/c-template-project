######################################
# target
######################################
TARGET = template

######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization
OPT = -O0

#######################################
# paths
#######################################
# Build path
BUILD_DIR = Build

######################################
# source
######################################
# C sources
C_SOURCES =  \
Src/main.c 

#######################################
# binaries
#######################################
PREFIX = 
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
endif

#######################################
# CFLAGS
#######################################
# C defines
C_DEFS =  

# C includes
C_INCLUDES =  \
-IInc

# compile gcc flags
CFLAGS = $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -Wextra -pedantic

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"


# default action: build all
all: $(BUILD_DIR)/$(TARGET)

#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@


$(BUILD_DIR)/$(TARGET): $(OBJECTS) Makefile
	$(CC) $(OBJECTS) -o $@

$(BUILD_DIR):
	mkdir $@

#######################################
# run
#######################################
run:
	$(BUILD_DIR)/$(TARGET).exe

#######################################
# clean up
#######################################
clean:
	@-rm -fR $(BUILD_DIR)



#######################################
# clean & run
#######################################




#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)
