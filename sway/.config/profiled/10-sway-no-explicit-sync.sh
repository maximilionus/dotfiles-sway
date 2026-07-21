# Disable WLR explicit sync for proprietary nvidia drivers.
#
# Fixes the screen flickering issues that occur on wlroots-based environments
# after the linux-drm-syncobj-v1 merge.
if lsmod | grep -q nvidia_drm; then
    export WLR_RENDER_NO_EXPLICIT_SYNC=1
fi
