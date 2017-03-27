#!/bin/bash

# Script for video streaming to local http server using python's inbuilt webserver
# NOTE: Needs echo, python, and vlc installed

# variables and inputs

dest_ip=""
vlc_screen_port="18080"
vlc_video_port="18081"
#http_port="8000"
#http_port="80"

script_path="$HOME/acda_2017/streaming_scripts"
tmp_file="/tmp/webstream.tmp"

screen_path="/screen.webm"
video_path="/video.webm"

screen_input="screen:// :screen-fps=10 :screen-caching=5"
#screen_input="screen:// :screen-fps=10 :screen-caching=100"
video_input="v4l2:// /dev/video0:fps=10"

webserver_log="httpserver.log"
vlc_screen_log="vlc_screen.log"
vlc_video_log="vlc_video.log"

process_group="$$"

# SCRIPT

# check input file exists (exit if not)
#if [ ! -f ${input_file} ]; then
#    /bin/echo "${input_file} not found!";
#    exit 1;

start_webserver() {
/bin/echo "Attempting to start web server in background [log located in ${script_path}]";
cd ${script_path};
python -m SimpleHTTPServer ${http_port} &> ${webserver_log} &
#sudo python -m SimpleHTTPServer ${http_port} &> ${webserver_log} &

}

start_vlcstreams() {
/bin/echo "Attempting to start vlc with screen input for http in background [log located in ${script_path}]";

# webm transcode in vp80 THIS WORKS
cvlc ${screen_input} --no-sout-standard-sap --sout-keep --ttl=20 --sout="#transcode{vcodec=VP80,vb=800}:std{access=http{mime=video/webm},mux=webm,dst=${dest_ip}:${vlc_screen_port}${screen_path}}" > ${vlc_screen_log} &

#cvlc ${screen_input} --no-sout-standard-sap --sout-keep --ttl=20 --sout="#transcode{vcodec=VP80,vb=1024}:std{access=http{mime=video/webm},mux=webm,dst=${dest_ip}:${vlc_screen_port}${screen_path}}" > ${vlc_screen_log} &

# webm transcode in vp80 resolution changes THIS WORKS
#cvlc -v ${screen_input} --no-sout-standard-sap --sout-keep --ttl=20 --sout="#transcode{vcodec=VP80,vb=2048,width=1280,height=720,channels=1,samplerate=44100}:std{access=http{mime=video/webm},mux=webm,dst=${dest_ip}:${vlc_screen_port}${screen_path}}" > ${screen_log} &

# From web - mp4
#cvlc -v ${screen_input} --sout '#transcode{vcodec=mp4v,acodec=mpga,vb=800,ab=128}:standard{access=http,mux=ogg,dst=:${vlc_port}${screen_path}}'

# Nathan's original transcode options - theo and ogg
#cvlc ${screen_input} --no-sout-standard-sap --sout-keep --ttl=20 --sout="#transcode{vcodec=theo,vb=1024,width=1024,height=720,fps=10,channels=1,samplerate=22050,acodec=acc}:std{access=http{mime=video/ogg},mux=ogg,dst=${dest_ip}:${vlc_screen_port}${screen_path}}" > ${vlc_screen_log} &

/bin/echo "Attempting to start vlc with video input for http in background [log located in ${script_path}]";
cvlc ${video_input} --no-sout-standard-sap --sout-keep --ttl=20 --sout="#transcode{vcodec=VP80,vb=800,}:std{access=http{mime=video/webm},mux=webm,dst=${dest_ip}:${vlc_video_port}${video_path}}" > ${vlc_video_log} &

#cvlc -v ${video_input} --no-sout-standard-sap --sout-keep --ttl=20 --sout="#transcode{vcodec=VP80,vb=2048,width=1280,height=720,channels=1,samplerate=44100}:std{access=http{mime=video/webm},mux=webm,dst=${dest_ip}:${vlc_video_port}${video_path}}"

#cvlc -v ${video_input} --no-sout-standard-sap --sout-keep --ttl=20 --sout="#transcode{vcodec=theo,vb=1024,width=1024,height=720,fps=20,channels=1,samplerate=22050,acodec=acc}:std{access=http{mime=video/ogg},mux=ogg,dst=${dest_ip}:${vlc_video_port}${video_path}}" > ${vlc_video_log} &

}

# MAIN
case "${1}" in
    start)
	echo ${process_group} > ${tmp_file}
	start_webserver
	start_vlcstreams
        ;;
    stop)
	process_group=$(cat ${tmp_file})
	rm ${tmp_file}
	kill -- -${process_group}
	;;
    *)
	echo "Specify start or stop of webstreams and server"
	exit 1
	;;
esac



################################
## OLD TESTING
################################
# case "${1}" in
#     screen)
# 	input_device="screen:// :screen-fps=20 :screen-caching=100"
#         ;;
#     video1)
# 	input_device="v4l2:// /dev/video0:fps=10"
# 	;;
#     video2)
# 	input_device="v4l2:// /dev/video1:fps=10"
# 	;;
#     video3)
# 	input_device="v4l2:// /dev/video2:fps=10"
# 	;;
#     video4)
# 	input_device="v4l2:// /dev/video3:fps=10"
# 	;;
#     *)
# 	echo "Specify screen or video"
# 	exit 1
# 	;;
# esac

# http webserver version with audio
#cvlc ${input_device} --no-sout-standard-sap --sout-keep --ttl=20 --sout="#transcode{vcodec=theo,vb=2048,width=1280,height=720,fps=20,channels=1,samplerate=22050,acodec=acc}:std{access=http{mime=video/ogg},mux=ogg,dst=${dest_ip}:${net_port}${stream_path}}"

# vlc client version
#cvlc ${input_device} --sout "#transcode{vcodec=wmv2,vb=256,scale=1,fps=10}:duplicate{dst=std{access=http{mime=video/x-ms-wmv},mux=asf,dst=${dest_ip}:${net_port}${stream_path}}}";
#echo "cvlc ${input_device} --sout '#transcode{vcodec=wmv2,vb=256,scale=1,fps=25}:duplicate{dst=std{access=http{mime=video/x-ms-wmv},mux=asf,dst=${dest_ip}:${net_port}${stream_path}}}'"

