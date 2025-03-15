# Installation

```bash
curl https://raw.githubusercontent.com/XenonIsAwesome/brb/refs/heads/main/brb.sh | bash
```

# Usage
```bash
usage: brb [-v VERSIONS] [--push] [--no-depends] {uhd,build-runner}

positional arguments:
  {build-runner/uhd}    The name of the target you want built.

options:
  -v VERSIONS, --version VERSIONS 
                        A version for a specific dependancy in a KEY=VALUE format.
                        KEYS = IPP
                               CMake
                               CUDA
                               CUDA_Driver
                               Boost
                               MQ_C
                               AMPQ
                               UHDBuilder
                               UHD
                               BuildRunner

  --registry            Registry to push to.
  --push                Push images to registry.
  --no-depends          Build without dependencies.
```

## Examples

```bash
brb uhd -v UHD=4.7.0.0
brb build-runner --no-depends -v BuildRunner=jammy --push
```