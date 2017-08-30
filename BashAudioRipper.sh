grabando=false
echo "Escuchando..."
while : 
do
     if pactl list | grep -B1 "Name: alsa_output.pci-0000_00_14.2.iec958-stereo$" | grep "RUNNING" -q
     then
        if [ "$grabando" = false ] ; then
            start=`date +%s` 
            pacat --record -d alsa_output.pci-0000_00_14.2.iec958-stereo.monitor --file-format=wav "$start.wav" &
            pid=$!
            grabando=true
            echo "Grabando..."
        fi
      else
        if [ "$grabando" = true ] ; then
            kill -9 $pid
            end=`date +%s`
            duration=$((end-start ))
            minutos=$((duration/60))
            segundos=$((duration%60)) 
            echo "Grabación finalizada. La duración fue: $minutos minutos con $segundos segundos. Aguarde a que se cree el archivo mp3";
            grabando=false
            ffmpeg -i "$start.wav" -ab 192k "$start.mp3" -loglevel quiet && rm "$start.wav" &&  echo "Se creó el archivo $start.mp3. Enjoy :D" &
        fi
     fi
done
