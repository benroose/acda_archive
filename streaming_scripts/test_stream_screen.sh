#!/bin/bash

# TESTING Script to video stream to local http server and use python's inbuilt webserver
# NOTE: Needs echo, python, and vlc installed

# variables and inputs

dest_ip="";
vlc_port="18080";
http_port="8000";
stream_path="/stream.webm";
#stream_path="/stream.wmv";

input_screen="screen:// :screen-fps=20 :screen-caching=100"
input_video="v4l2:// /dev/video0:fps=20"

case "${1}" in
    screen)
	input_device="screen:// :screen-fps=20 :screen-caching=100"
        ;;
    video1)
	input_device="v4l2:// /dev/video0:fps=10"
	;;
    video2)
	input_device="v4l2:// /dev/video1:fps=10"
	;;
    video3)
	input_device="v4l2:// /dev/video2:fps=10"
	;;
    video4)
	input_device="v4l2:// /dev/video3:fps=10"
	;;
    *)
	echo "Specify screen or video"
	exit 1
	;;
esac

# SCRIPT

# check input file exists (exit if not)
#if [ ! -f ${input_file} ]; then
#    /bin/echo "${input_file} not found!";
#    exit 1;

/bin/echo "Attempting to stream from ${input_device}";

# http webserver version no audio
cvlc ${input_device} --no-sout-standard-sap --sout-keep --ttl=20 --sout="#transcode{vcodec=theo,vb=2048,width=1280,height=720,fps=20}:std{access=http{mime=video/ogg},mux=ogg,dst=${dest_ip}:${net_port}${stream_path}}"

# http webserver version with audio
#cvlc ${input_device} --no-sout-standard-sap --sout-keep --ttl=20 --sout="#transcode{vcodec=theo,vb=2048,width=1280,height=720,fps=20,channels=1,samplerate=22050,acodec=acc}:std{access=http{mime=video/ogg},mux=ogg,dst=${dest_ip}:${net_port}${stream_path}}"

# vlc client version
#cvlc ${input_device} --sout "#transcode{vcodec=wmv2,vb=256,scale=1,fps=10}:duplicate{dst=std{access=http{mime=video/x-ms-wmv},mux=asf,dst=${dest_ip}:${net_port}${stream_path}}}";
#echo "cvlc ${input_device} --sout '#transcode{vcodec=wmv2,vb=256,scale=1,fps=25}:duplicate{dst=std{access=http{mime=video/x-ms-wmv},mux=asf,dst=${dest_ip}:${net_port}${stream_path}}}'"
