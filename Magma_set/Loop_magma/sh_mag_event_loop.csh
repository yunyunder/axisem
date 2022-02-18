#!/bin/csh -f
# project to new station! Jan 13 2022
#
gmt set MAP_FRAME_TYPE plain
gmt set FORMAT_GEO_MAP .x
gmt set FONT 12p

set loop_path = /home/yin/Magma_set/Loop_magma
set axi_path = /home/yin/axisem/SOLVER

set slon = 121.5659
set slat = 25.2518
set snet = FA
set sname = YC03
#echo 'project with new station '
#set slon = 121.5348
#set slat = 25.2160
#set snet = FA
#set sname = VO08

set range = 121/122.5/24.6/25.8 
set range_km = 0/100/0/40
set rangeCS = 0/1/0/40
set bin = -BWSne
set binx = -Bxa20f10
set biny = -Bya20f10
#set CPT = /home/yin/Loop_aimbat/dv.cpt
set CPT = dv.cpt
set grd_vp = tmp_grd_vp
set grd_vs = tmp_grd_vs
set proj = -JX2.2i/-0.8i



gmt makecpt -Chot -D -T-100/0/2  > $CPT
#gmt makecpt -Cjet -D -T-100/0/2 -I   > $CPT

#foreach mag (`cat magma_list`)
#set mag = r_10_d_15_dvp_-30.0_dvs_-30.0
set mag = r_10_d_15_dvp_-19.0_dvs_-33.0
    set mag_rad = `echo $mag | awk -F'_' '{print $2}'`
    set title = `echo $mag | awk -F'_' '{print "Vp= "$6"%, Vs= "$8"%"}'`
    set subtitle = `echo $mag | awk -F'_' '{print "Radius="$2"km, Depth="$4"km" }'`

    foreach event (`cat event_list`)
    #set event = 20190312_20
    #set event = 20151128_00

        #set elon = `grep longitude USED_CMT/$event | awk '{print $2}' `
        #set elat = `grep latitude USED_CMT/$event  | awk '{print $2}'`
        set elon = `grep longitude CMT/$event | awk '{print $2}' `
        set elat = `grep latitude CMT/$event  | awk '{print $2}'`
        echo $elon, $elat
        set PS = fig_${event}_${mag}


        #- CALCULATE AZIMUTH ANGEL
        ## cd ../src_misc
        echo $elat  $elon   > input
        echo $slat  $slon   >> input
        ./delaz < input > output
        set az = `sed -n '4p' output | awk '{print $2}'`
        set az2 = `sed -n '4p' output | awk '{print $3}'`
        echo $az, $az2
        ##cd $dir

        if (`echo "$elon > $slon" | bc` == 1  ) set az = $az2
        echo "The azimuth of source and $sname is  $az "


        ### fake_station
        set STATIONS = ${event}_${mag}_STATIONS
        set fake = fake_sta
        set dist = 500
        set mark = `echo $dist | awk '{print $1/10+1}'`
        gmt project -C$elon/$elat -A$az -L1/$dist -G1 -Q > $fake
        #gmt project -C$elon/$elat -E$slon/$slat -G5/100 -Q > fake_sta
        ##echo $sname $snet $slat $slon  "0.0  0.0" > $STATIONS
        cat STATIONS_ALLTW > $STATIONS
        #sed -i '1d' $fake
        ##sed -i '$d' $fake
        cat $fake | awk '{printf "Y%03d YY %.4f  %.4f  0.0 0.0\n" , $3 ,$2, $1 }' >> $STATIONS

        ### prepare 
        rm -f tmp* 
        gmt project USED_MAG/$mag -C$elon/$elat -E$slon/$slat -W-0.01/0.01  -Fxyzpqrs  > tmp
        cat tmp | awk '{print $7*111,$3, $4}' > tmp_km
        gmt triangulate -R$range_km tmp_km -G$grd_vp -T0.25 -I0.5/0.5

        cat tmp | awk '{print $7*111,$3, $5}' > tmp_km
        gmt triangulate -R$range_km tmp_km -G$grd_vs -T0.25 -I0.5/0.5

        cat tmp | wc -l > ${event}_${mag}.sph
        cat tmp | awk '{print 6371-$3, $7, $4, $5, $6}' >> ${event}_${mag}.sph

        gmt begin $PS png
            gmt coast -R$range -JM3i -X3.5i  -Bxa1f0.5 -Bya0.5f0.2 -BWNes -Ggrey -W0.3p 
            echo 121.623 25.21 0 360 | gmt plot -SW$mag_rad -Gred

            #awk '{print $1, $2}' $fake | gmt plot -St3p -Ggreen -W0.3p
            awk 'NR==1; END{print $1,$2}' $fake | gmt plot -Sf-$mark/0.1i+l+f -W
            echo $slon $slat | gmt plot -St5p -Gblue -W0.3p
            echo $elon $elat | gmt plot -Sa8p  -Gyellow -W0.3p
            gmt text -F+f8p -D0/10p << EOF
            $slon $slat $sname 
            $elon $elat $event
EOF


            gmt grdimage $grd_vs -R$range_km $proj $binx+l'Epicentral Distance (km)' \
                         $biny $bin -X3.5i -Y0.5i -C$CPT -E200
            echo 93 33 dvs | gmt pstext -C+tO -Gwhite -W0.01p
            gmt colorbar -C$CPT -Ba20f5 -B+t'%' -DjBR+w3c/0.1c+o-0.7/0c+v 
            #gmt plot tmp_km -Sc1p

            
            gmt grdimage $grd_vp -R$range_km $proj $bin $binx $biny -C$CPT -Y1.2i
            echo 93 33 dvp | gmt pstext -C+tO -Gwhite  -W0.01p
            gmt pstext -N << EOF
            50 -20 $title
            50 -10 $subtitle
EOF


        gmt end

## for auto submit jobs to axisem/SOLVER         
#        mv $STATIONS STATIONS
#        \cp CMT/$event .
#        mv $event CMTSOLUTION
#        \cp ${event}_${mag}.sph  magma.sph
#        \cp magma.sph CMTSOLUTION STATIONS  $axi_path
#        \cp inparam* $axi_path
#        \cp submit.csh $axi_path 
#        cd $axi_path
#
#        # run jobs 
#        ./submit.csh PREM_1s_${event}_${mag}_Y100 -q torque
#        ##./submit.csh PREM_2s_${event}_${sname} -q torque
#        cd $loop_path
#
#        eog $PS.png

    end #event 

#end #mag


eog *png
