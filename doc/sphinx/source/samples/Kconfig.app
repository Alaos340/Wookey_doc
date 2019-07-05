# starting PIN application configuration
menu "PIN custom app"

config APP_PIN
  bool "Pin App"
  depends on STM32F4
  default y
  ---help---
    Say y if you want to embbed USER custom application.

# start of (de)actication PIN option list
# all the config entry here depends on the activation of the application
if APP_PIN

config APP_PIN_FW
  bool "Pin App for firmware mode"
  depends on STM32F4
  default y
  ---help---
    Say y if you want to embbed Pin custom application in firmware.

config APP_PIN_DFU
  bool "Pin App for DFU mode"
  depends on FIRMWARE_DFU
  depends on STM32F4
  default y
  ---help---
    Say y if you want to embbed Pin custom application in DFU.


config APP_PIN_NUMSLOTS
  int "Number of required slots"
  default 1
  ---help---
    specify the number of slots required by the application text and data/bss.
    remember that the number of total slots is limited by the hardware.
    For example, there is 8 32kb sized slots in STM32F4, reduced to 7 when using SHM for
    .text + .data in flash, and 8 (reduced to 7 with SHM) slots of 16kb in RAM.
    This choice has an impact on the total number of applications that can be loaded
    in the firmware.

config APP_PIN_STACKSIZE
  int "Stack size"
  default 8192
  ---help---
    Specify the application stack size, in bytes. By default, set to 8192
    (i.e. 8k). Depending on the number of slots required, and the usage,
    the stack can be bigger or smaller.


# start of PIN permission configuration
menu "Permissions"

menu "Devices"

config APP_PIN_PERM_DEV_DMA
    bool "App has capacity to register DMA streams"
    default n
    ---help---
    if no, the application can't declare a DMA. If y, the application
    is able to require one or more secure DMA stream(s).

config APP_PIN_PERM_DEV_CRYPTO
    int "App can interact with HW cryptographic module"
    default 0
    range 0 3
    ---help---
    If 0, the application has no access to any HW cryp module.
    If 1, the application is able to use a HW cryp module configured
    by another application.
    If 2, the application is able to configure (inject keys) but can't
    use the crypt module (no IRQ handler).
    If 3, the application as a full, autonomous access to the HW cryp
    module

config APP_PIN_PERM_DEV_BUSES
    bool "App has capacity to use buses (SPI, I2C, USART...)"
    default n
    ---help---
    If n, the application can't access any buses (I2C, SPI, USART).
    If y, the application can require a bus mapping.

config APP_PIN_PERM_DEV_EXTI
    bool "App can use EXTI or GPIO driven external interrupts"
    default n

config APP_PIN_PERM_DEV_TIM
    bool "App can register a hardware timer"
    default n
    ---help---
    If n, the application can't require a timer from the kernel (using
    the timer API). If y, the application can require one or more HW
    timer(s).

endmenu

menu "Time"

config APP_PIN_PERM_TIM_GETCYCLES
    int "App has capacity to get current timestamp from kernel"
    default 0
    range 0 3
    ---help---
    If 0, the application has no access to timestamping.
    If 1, the application is able to get tick accurate timestamping.
    If 2, the application is able to get microsecond accurate timestamping.
    If 3, the application is able to get cycle accurate timestamping.

endmenu

menu "Tasking"

config APP_PIN_PERM_TSK_FISR
    bool "App is allowed to request main thread execution after ISR"
    default n
    ---help---
    If y, the application is able to request its main thread execution
    just after specific ISRs. This is done using the dev_irq_mode_t
    structure in device_t struct, using the IRQ_ISR_FORCE_MAINTHREAD value.
    If n, this field can't be set to this value.

config APP_PIN_PERM_TSK_FIPC
    bool "App is allowed to request peer execution on syncrhnous send IPC"
    default n
    ---help---
    If y, the application is able to request peer thread execution
    when sending syncrhonous IPC.

config APP_PIN_PERM_TSK_RESET
    bool "App is allowed to request a board software reset"
    default n
    ---help---
    If y, the application is able to request a MCU reset. This is usefull
    only if the application is handling events that require urgent reactivity
    implying board reset.

config APP_PIN_PERM_TSK_UPGRADE
    bool "App is allowed to upgrade the firmware"
    default n
    ---help---
    If y, the application is able to map the embedded flash device in
    order to upgrade the overall firmware. This permission should
    be hosted by a task with no external access (USB, USART...)



endmenu

menu "Memory management"

config APP_PIN_PERM_MEM_DYNAMIC_MAP
    bool "App is allow to declare MAP_VOLUNTARY devices"
    default n
    ---help---
    If y, the task is allowed to declare devices that are not automatically
    mapped, but that are mapped/unmapped voluntary using sys_cfg() syscalls.
    This permission does not give access to any devices not already declared
    but allow dynamic (un)mapping of previously declared ones.

endmenu


endmenu
# end of PIN permission configuration

# Here we can add one (or more) menu, submenu and so on, which
# are specific to the application behavior.
# The menu structure is free, but the option prefix should respect
# the global application prefix (here APP_PIN) to avoid any collision
# or confusion with other part of the configuration
#
# start of PIN specific option configuration
menu "Application specific options"

choice
  prompt "PIN human interaction mode"
  default APP_PIN_INPUT_USART
    config APP_PIN_INPUT_USART
      bool "PIN is asked through USART"
      ---help---
      User interaction for PIN ask is done using dedicated
      USART interface
    config APP_PIN_INPUT_SCREEN
      bool "PIN is asked through graphical interface"
      ---help---
      User interaction for PIN ask is done using dedicated
      screen/touchscreen couple
endchoice

if APP_PIN_INPUT_USART
  config APP_PIN_INPUT_USART_ID
  int "PIN USART interface identifier"
  range 1 6
endif

endmenu
# end of PIN specific option configuration

# end of (de)actication PIN option list
endif

endmenu
# end of PIN application configuration