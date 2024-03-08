# Package Dependency

## Abstract

```text
                   
                   +------------+                                  +----------------+
                   | libx11-dev |                                  | libwayland-dev |
                   +------+-----+                                  +-------+--------+
                          |                                                |
                          +-----------------+-----------------+            |
                          |                 |                 |            |
+-------+-------+  +------+-----+    +------+------+  +-------+-------+    |    +---------------+
| libopengl-dev |  | libglx-dev |    | libxext-dev |  |libxrender-dev |    |    | libvulkan-dev |
+-------+-------+  +------+-----+    +------+------+  +-------+-------+    |    +-------+-------+
        |                 |                 |                 |            |            |
        |           +-----+-----+           +--------+--------+            |            |
        |           | libgl-dev |                    |                     |            |
        |           +-----+-----+            +-------+-------+             |            |
        |                 |                  | libxrandr-dev |             |            |
        |          +------+-----+            +-------+-------+             |            |
        |          | libegl-dev |                    |                     |            |
        |          +------+-----+                    |                     |            |
        |                 |                          |                     |            |
        |         +-------+-----+                    |                     |            |
        |         | libgles-dev |                    |                     |            |
        |         +------+------+                    |                     |            |
        |                |                           |                     |            |
        +--------+-------+                           |                     |            |
                 |                                   |                     |            |
          +------+-------+                           |                     |            |
          | libglvnd-dev |                           |                     |            |
          +------+-------+                           |                     |            |
                 |                                   |                     |            |
         +-------+------------+                      |                     |            |
         |                    |                      |                     |            |
+--------+--------+  +--------+---------+            |                     |            |
| libgl1-mesa-dev |  | libegl1-mesa-dev |            |                     |            |
+--------+--------+  +--------+---------+            |                     |            |
         |                    |                      |                     |            |
         +--------------------+----------------+-----+---------------------+------------+
                                               |
                                        +------+-------+
                                        | libglfw3-dev |
                                        +--------------+
```

## `libgl1-mesa-dev` or `libegl1-mesa-dev`

- `libgl1-mesa-dev` _or_ `libegl1-mesa-dev`
   * `libglvnd-dev`
      - `libgles-dev`
         * libgles1
         * libgles2 
         * `libegl-dev`
            - libegl-mesa0 
            - libegl1 
            - libgbm1
            - libwayland-client0
            - libwayland-server0
            - `libgl-dev`
               * libgl1
               * `libglx-dev`
                  - libdrm-amdgpu1 
                  - libdrm-intel1 
                  - libdrm-nouveau2 
                  - libdrm-radeon1  
                  - libgl1-amber-dri
                  - libgl1-mesa-dri
                  - libglapi-mesa
                  - libglvnd0
                  - libglx-mesa0
                  - libglx0
                  - libllvm15
                  - libpciaccess0
                  - libsensors-config
                  - libsensors5
                  - `libx11-dev`
                     * libpthread-stubs0-dev
                     * libxau-dev
                     * libxcb1-dev
                     * libxdmcp-dev
                     * x11proto-dev
                     * xorg-sgml-doctools
                     * xtrans-dev
                  - libx11-xcb1
                  - libxcb-dri2-0
                  - libxcb-dri3-0
                  - libxcb-glx0
                  - libxcb-present0
                  - libxcb-randr0
                  - libxcb-shm0
                  - libxcb-sync1
                  - libxcb-xfixes0
                  - libxfixes3
                  - libxshmfence1
                  - libxxf86vm1 
      - libglvnd-core-dev
      - `libopengl-dev`
         * libopengl0

## `libwayland-dev`

- `libwayland-dev`
   * libffi-dev 
   * libwayland-bin 
   * libwayland-client0 
   * libwayland-cursor0
   * libwayland-egl1 
   * libwayland-server0

## `libvulkan-dev`

- `libvulkan-dev`
   * libdrm-amdgpu1 
   * libllvm15 
   * libvulkan1 
   * libwayland-client0 
   * libx11-xcb1
   * libxcb-dri3-0 
   * libxcb-present0 
   * libxcb-randr0 
   * libxcb-shm0 
   * libxcb-sync1
   * libxcb-xfixes0 
   * libxshmfence1 
   * `mesa-vulkan-drivers`

## `libxrandr-dev` ( `libxext-dev`, `libxrender-dev` )

- `libxrandr-dev`
   * libxrandr2
   * `libxext-dev`
      - `libx11-dev` (commit below)
   * `libxrender-dev`
      - libxrender1
      - `libx11-dev` (commit below)

