#!bin/bash

# This workaround is required to "save" nvidia-settings powermizer settings since it doesn't store it by default. Figures.
nvidia-settings -a '[gpu:0]/GPUPowerMizerMode=1'
