#!/bin/bash

####################################################################
# VARIABLES DE RUTAS
####################################################################

conecta="--host=${host} --user=root --port=${port} --password=${pass}"
soft="build-essential expect git git-core clang cmake make gcc g++ automake autoconf patch libmariadbclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev mariadb-server p7zip-full default-libmysqlclient-dev libace-6.* libace-dev libtool grep binutils zlibc libc6 subversion wget tmux"
repos=$HOME/Repos
servers=$HOME/Servers
repo_tc335="-b 3.3.5 git://github.com/TrinityCore/TrinityCore.git"
db_tc335=https://github.com/TrinityCore/TrinityCore/releases/download/TDB335.20091/TDB_full_world_335.20091_2020_09_15.7z
server_tricore=$HOME/Servers/TrinityCore
# OBTENGO NOMBRE DE ACHIVO COMPRIMIDO DE BASE DE DATOS
arch_comp_db_tc335=$(basename "$db_tc335")
# OBTENGO NOMBRE DE ACHIVO SQL
arch_sql_db_tc335=${arch_comp_db_tc335%.*}.sql

backtitle="https://catlinux.es"
link_data335=https://arxius.tronosdesangre.es/index.php/s/YJWw6m9EWF52mAe


if [ ! -x /usr/bin/dialog  ];then
	clear
	echo "Parece que no tienes DIALOG instalado.
	Vamos a instalarlo para poder continuar"
	sudo apt-get install dialog
fi
	printf "\e[8;35;100;t"
	clear
	dialog --title "INFORMACIÓN" \
	--backtitle $backtitle \
	--msgbox "\nEstos datos son necesarios para la conexión a la base de datos o para poder compilar sin problemas. \nPon valores que sean reales o de lo contrario no funcionará correctamente el script." 10 70 && clear


####################################################################
# Opciones de configuración
####################################################################

cores=$(dialog --title "DATOS DE CONEXIÓN" \
--backtitle $backtitle \
--nocancel \
--inputbox "\nNº de cores que tienes en tu PC: \nValor por defecto 1" 10 51 1 2>&1 >/dev/tty)

auth=$(dialog --title "DATOS DE CONEXIÓN" \
--backtitle $backtitle \
--nocancel \
--inputbox "\nBase de datos auth: \nValor por defecto auth" 10 51 auth 2>&1 >/dev/tty)

char=$(dialog --title "DATOS DE CONEXIÓN" \
--backtitle $backtitle \
--nocancel \
--inputbox "\nBase de datos characters: \nValor por defecto characters" 10 51 characters 2>&1 >/dev/tty)

world=$(dialog --title "DATOS DE CONEXIÓN" \
--backtitle $backtitle \
--nocancel \
--inputbox "\nBase de datos world: \nValor por defecto world" 10 51 world 2>&1 >/dev/tty)

host=$(dialog --title "DATOS DE CONEXIÓN" \
--backtitle $backtitle \
--nocancel \
--inputbox "\nDirección IP del host: \nValor por defecto localhost" 10 51 localhost 2>&1 >/dev/tty)

port=$(dialog --title "DATOS DE CONEXIÓN" \
--backtitle $backtitle \
--nocancel \
--inputbox "\nPuerto de MySQL: \nValor por defecto 3306" 10 51 3306 2>&1 >/dev/tty)

#user=$(dialog --title "DATOS DE CONEXIÓN" \
#--backtitle $backtitle \
#--nocancel \
#--inputbox "\nUsuario de MySQL: \nValor por defecto root" 10 51 root 2>&1 >/dev/tty)

pass=$(dialog --title "DATOS DE CONEXIÓN" \
--backtitle $backtitle \
--nocancel \
--insecure \
--passwordbox "\nContraseña de MySQL: " 10 51 2>&1 >/dev/tty)

dialog --title "INFORMACIÓN" \
--backtitle $backtitle \
--msgbox "\nGracias por tus respuestas. Ahora ya podemos continuar con la instalación." 8 50 && clear
clear


#####################################################################################################
# Menú de emuladores disponibles
#####################################################################################################
dialog --title "Menú de opciones --- Creado por MSANCHO" \
--backtitle $backtitle \
--nocancel \
--menu "\nEmulador que deseas compilar:" 20 80 11 \
"i - Información - Guía de uso" "" \
"1 - Instalar programas preparación - esenciales" "" \
"4 - Trinitycore versión 3.3.5a (12340)" "" \
"5 - PRÓXIMAMENTE - Conexión por Telnet a nuestro servidor" "" \
"6 - PRÓXIMAMENTE - Copias de seguridad de las Bases de Datos" "" \
"9 - PRÓXIMAMENTE - Crea tu web de registro de cuentas" "" \
"0 - Salir de la aplicación" "" 2> ~/var0
	  
opcion0=$(cat ~/var0)
	
if [ "$opcion0" = "0 - Salir de la aplicación" ]; then
	rm ~/var*
	dialog --title "Menú de opciones --- Creado por MSANCHO" \
	--msgbox "\nGracias por usar el script de instalación." 10 50
	clear
fi
	
while [ "$opcion0" != "0 - Salir de la aplicación" ]; do


####################################################################
# i - Guía de uso
####################################################################
if [ "$opcion0" = "i - Información - Guía de uso" ]; then
	dialog --title "Menú de opciones --- Creado por MSANCHO" \
	--backtitle $backtitle \
	--nocancel \
	--menu "\nGuía de uso" 20 60 8 \
	"1 - Leer en pantalla" "" \
	"2 - Guardar como archivo" "" \
	"0 - Volver" "" 2> ~/var2
	  
	opcion2=$(cat ~/var2)
	rm ~/var*

	while [ "$opcion2" != "0 - Volver" ]; do


####################################################################
# Leer en pantalla
####################################################################
	if [ "$opcion2" = "1 - Leer en pantalla" ]; then
		clear
		cd ~/ && wget https://github.com/downloads/tortosi/Instalador/manual.txt
		dialog --textbox manual.txt 40 120
		rm ~/manual*.txt


####################################################################
# Guardar como archivo
####################################################################
	elif [ "$opcion2" = "2 - Guardar como archivo" ]; then
		clear
		cd ~/Documentos && wget https://github.com/downloads/tortosi/Instalador/manual.txt
		dialog --title "INFORMACIÓN" \
		--backtitle $backtitle \
		--msgbox "\nSe ha guardado una copia del manual en:\n$HOME/Documentos." 10 45 && clear
	fi


########  CONCLUSIÓN MENÚ Guía de uso  ######## 
	dialog --title "Menú de opciones --- Creado por MSANCHO" \
	--backtitle $backtitle \
	--nocancel \
	--menu "\nGuía de uso" 20 60 8 \
	"1 - Leer en pantalla" "" \
	"2 - Guardar como archivo" "" \
	"0 - Volver" "" 2> ~/var2
	  
	opcion2=$(cat ~/var2)
	rm ~/var*
	done


####################################################################
# 1 - Instalar programas preparación - esenciales
####################################################################
elif [ "$opcion0" = "1 - Instalar programas preparación - esenciales" ]; then
	dialog --title "INFORMACIÓN" \
	--backtitle $backtitle \
	--nocancel \
	--msgbox "\nProcedemos a instalar los programas necesarios para recibir los repositorios, bases de datos, MySQL, apache2, compilar, librerías necesarias, etc...\n\nEste proceso puede demorar unos 5 minutos o más, dependiendo de tu equipo.\n\nProbablemete te pida algún dato para las configuraciones de MySQL." 14 70
	clear && sudo apt-get install $soft -y
	sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
	sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
	
	# AJUSTES DE MARIADB

	sudo mysql $conecta <<_EOF_
	UPDATE mysql.user SET Password=PASSWORD('${pass}') WHERE User='root';
	DELETE FROM mysql.user WHERE User='';
	DROP DATABASE IF EXISTS test;
	DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
	USE mysql;
	UPDATE user SET plugin="mysql_native_password" WHERE user="root";
	FLUSH PRIVILEGES;
_EOF_

	dialog --title "INFORMACIÓN" \
	--backtitle $backtitle \
	--nocancel \
	--pause "\nSe han instalado los programas imprescindibles para la compilación.\n" 10 70 5
	dialog --title "INFORMACIÓN" \
	--backtitle $backtitle \
	--nocancel \
	--msgbox "\nProcedemos a las librerias ACE y TBB." 12 70
sudo apt-get install -qq libace-dev
export ACE_ROOT=/usr/include/ace
sudo apt-get install -y libtbb-dev
export TBB_ROOT_DIR=/usr/include/tbb
	dialog --title "INFORMACIÓN" \
	--backtitle $backtitle \
	--msgbox "\nYa tenemos todo el software necesario instalado. Ya puedes seguir con los otros pasos." 8 50 && clear


#####################################################################################################
# Menú - Trinitycore versión 3.3.5a (12340)
#####################################################################################################
elif [ "$opcion0" = "4 - Trinitycore versión 3.3.5a (12340)" ]; then
	dialog --title "Menú de opciones --- Creado por MSANCHO" \
	--backtitle $backtitle \
	--nocancel \
	--menu "\nOpciones disponibles:" 20 80 11 \
	"1 - Obtención o actualización de todos los archivos necesarios" "" \
	"2 - Compilar el emulador" "" \
	"3 - DBC's, maps y vmaps - Descarga y colocación en directorio" "" \
	"4 - Instalar las Bases de Datos" "" \
	"6 - Configuraciones varias" "" \
	"0 - Salir de la aplicación" "" 2> ~/var50
	  
	opcion50=$(cat ~/var50)
	
	if [ "$opcion50" = "0 - Salir de la aplicación" ]; then
		rm ~/var*
		dialog --title "Menú de opciones --- Creado por MSANCHO" \
		--msgbox "\nGracias por usar el script de instalación." 10 50
		clear
		exit
	fi
	while [ "$opcion50" != "0 - Salir de la aplicación" ]; do


####################################################################
# Menú - Obtención o actualización de todos los archivos necesarios
####################################################################
	if [ "$opcion50" = "1 - Obtención o actualización de todos los archivos necesarios" ]; then
		dialog --title "Menú de opciones --- Creado por MSANCHO" \
		--backtitle $backtitle \
		--nocancel \
		--menu "\nManejo de Repositorios y archivos" 20 60 8 \
		"1 - Descargar repositorios" "" \
		"2 - Actualizar repositorios" "" \
		"0 - Volver" "" 2> ~/var51
			  
		opcion51=$(cat ~/var51)
		rm ~/var*
	
		while [ "$opcion51" != "0 - Volver" ]; do


####################################################################
# Descargar repositorios
####################################################################
		if [ "$opcion51" = "1 - Descargar repositorios" ]; then
			clear
			if [ ! -x $HOME/Repos  ];then
				dialog --title "INFORMACIÓN" \
				--backtitle $backtitle \
				--pause "\nSe va a crear la carpeta de repositorios dentro de nuestro home" 10 50 5
				clear
				cd $HOME/ && mkdir Repos
			fi
			if [ ! -x $HOME/Repos/TrinityCore  ];then
				dialog --title "INFORMACIÓN" \
				--backtitle $backtitle \
				--pause "\nVamos a obtener los repositorios de TrinityCore" 10 50 5
				clear
				cd $repos && git clone $repo_tc335
			fi
			if [ ! -x $HOME/Repos/TDB-335  ];then
				dialog --title "INFORMACIÓN" \
				--backtitle $backtitle \
				--pause "\nVamos a descargar la base de datos de TrinityCore 3.3.5." 10 50 5
				clear
				cd $HOME/Repos && mkdir TDB-335
				cd TDB-335 && wget $db_tc335
				7z e $arch_comp_db_tc335
			fi
			dialog --title "INFORMACIÓN" \
			--backtitle $backtitle \
			--msgbox "\nTodos los repositorios están descargados." 8 50
			clear


####################################################################
# Actualizar repositorios 
####################################################################
		elif [ "$opcion51" = "2 - Actualizar repositorios" ]; then
			clear && cd $repos/TrinityCore && git pull origin 3.3.5
			read -n 1 -s -r -p "Pulsa una tecla para continuar..." 
			dialog --title "INFORMACIÓN" \
			--backtitle $backtitle \
			--pause "\nRepositorios del core actualizados." 10 50 5
			clear
			dialog --title "INFORMACIÓN" \
			--backtitle $backtitle \
			--msgbox "\nYa puedes recommpilar el emulador de nuevo." 8 50
			clear
		fi


########  CONCLUSIÓN MENÚ Obtención o actualización de todos los archivos necesarios  ########  
		dialog --title "Menú de opciones --- Creado por MSANCHO" \
		--backtitle $backtitle \
		--nocancel \
		--menu "\nManejo de Repositorios y archivos" 20 60 8 \
		"1 - Descargar repositorios" "" \
		"2 - Actualizar repositorios" "" \
		"0 - Volver" "" 2> ~/var51
		
		opcion51=$(cat ~/var51)
		rm ~/var*
		done


####################################################################
# Compilar el emulador
####################################################################
	elif [ "$opcion50" = "2 - Compilar el emulador" ]; then
		if [ ! -x $repos/TrinityCore/build  ];then
			cd $repos/TrinityCore && mkdir build
		fi
		if [ ! -x $HOME/Servers  ];then
			cd $HOME && mkdir Servers
		fi
		cd $repos/TrinityCore/build  && clear
		cmake ../ -DCMAKE_INSTALL_PREFIX=$server_tricore -DTOOLS=0
		make -j$cores && make install
		cp $HOME/Repos/TDB-335/$arch_sql_db_tc335 $server_tricore/bin
		dialog --title "INFORMACIÓN" \
		--backtitle $backtitle \
		--msgbox "\nHas terminado de compilar tu emulador. Si todo ha salido correctamete lo encontrarás en tu home, dentro de la carpeta Servers/server_tricore" 9 50
		clear


####################################################################
# DBC's, maps y vmaps - Descarga y colocación en directorio
####################################################################
	elif [ "$opcion50" = "3 - DBC's, maps y vmaps - Descarga y colocación en directorio" ]; then
		if [ ! -x $server_tricore/data  ];then
			clear && cd $server_tricore
			wget --no-check-certificate --content-disposition $link_data335/download -O data_tc335.zip
			unzip data_tc335.zip && rm data_tc335.zip
			dialog --title "INFORMACIÓN" \
			--backtitle $backtitle \
			--msgbox "\nSe ha creado una carpeta llamada data con las dbc, maps, mmaps y vmaps en su interior" 8 50
			clear
		else
			dialog --title "INFORMACIÓN" \
			--backtitle $backtitle \
			--msgbox "\nYa está la carpeta data creada y no se han descargado los archivos.\n\nSi deseas reinstalarlos de nuevo, borra la carpeta data de tu directorio del servidor y ejecuta de nuevo este mismo paso" 12 50
		fi


####################################################################
# Instalar las Bases de Datos
####################################################################

	elif [ "$opcion50" = "4 - Instalar las Bases de Datos" ]; then
		dialog --title "Menú de opciones --- Creado por MSANCHO" \
		--backtitle $backtitle \
		--nocancel \
		--menu "\nInstalar las Bases de Datos" 20 80 8 \
		"1 - Crear las Bases de datos" "" \
		"2 - Poblar las Bases de datos" "" \
		"0 - Volver" "" 2> ~/var52

		opcion52=$(cat ~/var52)
		rm ~/var52
	
		while [ "$opcion52" != "0 - Volver" ]; do


####################################################################
# Instalar base de datos TDB
####################################################################
		if [ "$opcion52" = "1 - Crear las Bases de datos" ]; then
			dialog --title "ATENCIÓN!" \
			--backtitle $backtitle \
			--defaultno \
			--yesno "\nVas a eliminar cualquier base de datos que tenga los nombres ${world}, ${auth} y ${char} creándolas de nuevo con sus estructuras predeterminadas. ¿Estás seguro?" 10 50 
			if [ $? = 0 ]; then
				mysql $conecta -e "CREATE DATABASE IF NOT EXISTS ${world} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
				mysql $conecta -e "CREATE DATABASE IF NOT EXISTS ${char} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
				mysql $conecta -e "CREATE DATABASE IF NOT EXISTS ${auth} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
				mysql $conecta -e "GRANT ALL PRIVILEGES ON ${world} . * TO 'root'@'localhost' WITH GRANT OPTION;"
				mysql $conecta -e "GRANT ALL PRIVILEGES ON ${char} . * TO 'root'@'localhost' WITH GRANT OPTION;"
				mysql $conecta -e "GRANT ALL PRIVILEGES ON ${auth} . * TO 'root'@'localhost' WITH GRANT OPTION;"
				mysql $conecta -e "FLUSH PRIVILEGES;"
				dialog --title "INFORMACIÓN" \
				--backtitle $backtitle \
				--msgbox "\nFinalizada la creación de las bases de datos ${world}, ${auth} y ${char}." 10 50
				clear
			fi


####################################################################
# Poblar las Bases de datos
####################################################################
		elif [ "$opcion52" = "2 - Poblar las Bases de datos" ]; then
			dialog --title "ATENCIÓN!" \
			--backtitle $backtitle \
			--msgbox "\nEn TrinityCore, la inyección de datos en las tablas ${world}, ${auth} y ${char} se hacen\nautomáticamente al arranar el emulador." 10 50
				clear
			fi

########  CONCLUSIÓN MENÚ Instalar las Bases de Datos  ######## 
		dialog --title "Menú de opciones --- Creado por MSANCHO" \
		--backtitle $backtitle \
		--nocancel \
		--menu "\nInstalar las Bases de Datos" 20 80 8 \
		"1 - Crear las Bases de datos" "" \
		"2 - Poblar las Bases de datos" "" \
		"0 - Volver" "" 2> ~/var52
		  
		opcion52=$(cat ~/var52)
		rm ~/var52
		done


####################################################################
# Configuraciones varias
####################################################################
	elif [ "$opcion50" = "6 - Configuraciones varias" ]; then
		dialog --title "Menú de opciones --- Creado por MSANCHO" \
		--backtitle $backtitle \
		--nocancel \
		--menu "\nConfiguraciones varias" 20 80 8 \
		"1 - Configurar tabla realmlist de la base de datos auth" "" \
		"2 - Configurar authserver.conf y worldserver.conf" "" \
		"0 - Volver" "" 2> var55
		  
		opcion55=$(cat var55)
		rm var55

		while [ "$opcion55" != "0 - Volver" ]; do


####################################################################
# Configurar tabla realmlist de la base de datos auth
####################################################################
		if [ "$opcion55" = "1 - Configurar tabla realmlist de la base de datos auth" ]; then
			rm -f $server_tricore/etc/confrealm.sql
			echo "REPLACE INTO \`realmlist\` (\`id\`,\`name\`,\`address\`,\`localAddress\`,\`port\`,\`icon\`,\`color\`,\`timezone\`,\`allowedSecurityLevel\`,\`population\`,\`gamebuild\`) VALUES
(1,'NombreReino','addressReino','127.0.0.1',portReino,1,0,1,0,0,12340);" >> $server_tricore/etc/confrealm.sql

			conf6=$(dialog --title "CONFIGURACIÓN TABLA realmlist de la DB auth" \
			--backtitle $backtitle \
			--inputbox "\nNombre que le quieres dar a tu reino:" 10 51 Trinity 2>&1 >/dev/tty)
			sed -e "s/NombreReino/$conf6/g" -i $server_tricore/etc/confrealm.sql

			conf7=$(dialog --title "CONFIGURACIÓN TABLA realmlist de la DB auth" \
			--backtitle $backtitle \
			--inputbox "\nIp de conexión a tu servidor:" 10 51 127.0.0.1 2>&1 >/dev/tty)
			sed -e "s/addressReino/$conf7/g" -i $server_tricore/etc/confrealm.sql

			conf8=$(dialog --title "CONFIGURACIÓN TABLA realmlist de la DB auth" \
			--backtitle $backtitle \
			--inputbox "\nPuerto de conexión:" 10 51 8085 2>&1 >/dev/tty)
			sed -e "s/portReino/$conf8/g" -i $server_tricore/etc/confrealm.sql

			mysql $conecta $auth < $server_tricore/etc/confrealm.sql
			rm -f $server_tricore/etc/confrealm.sql
			dialog --title "INFORMACIÓN" \
			--backtitle $backtitle \
			--msgbox "\nYa tienes la Tabla realmlist configurada" 10 50
			clear


####################################################################
# Configurar authserver.conf y worldserver.conf
####################################################################
		elif [ "$opcion55" = "2 - Configurar authserver.conf y worldserver.conf" ]; then
			dialog --title "Menú de opciones --- Creado por MSANCHO" \
			--backtitle $backtitle \
			--nocancel \
			--menu "\nConfigurar authserver.conf y worldserver.conf" 20 80 8 \
			"1 - Configurar archivo authserver.conf" "" \
			"2 - Configurar archivo worldserver.conf" "" \
			"0 - Volver" "" 2> var56
			  
			opcion56=$(cat var56)
			rm var56

			while [ "$opcion56" != "0 - Volver" ]; do


####################################################################
# Configurar Authserver.conf
####################################################################
			if [ "$opcion56" = "1 - Configurar archivo authserver.conf" ]; then
				if [ ! -x $server_tricore/etc/authserver.temp  ];then
					rm -f $server_tricore/etc/authserver.temp
				fi
				cp $server_tricore/etc/authserver.conf.dist $server_tricore/etc/authserver.temp

				sed -e "s/LoginDatabaseInfo = \"127\.0\.0\.1;3306;trinity;trinity;auth\"/LoginDatabaseInfo = \"127\.0\.0\.1;3306;sqluser;sqlpass;dbauth\"/g" -i $server_tricore/etc/authserver.temp

				conf=$(dialog --title "CONFIGURACIÓN DEL authserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nDirectorio del archivo logs: \nValor por defecto logs" 10 51 logs 2>&1 >/dev/tty)
				sed -e "s/LogsDir = \"\"/LogsDir = \"\.\.\/$conf\"/g" -i $server_tricore/etc/authserver.temp

				conf3=$(dialog --title "CONFIGURACIÓN DEL authserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nUsuario de MySQL: \nValor por defecto root" 10 51 root 2>&1 >/dev/tty)
				sed -e "s/sqluser/$conf3/g" -i $server_tricore/etc/authserver.temp

				conf4=$(dialog --title "CONFIGURACIÓN DEL authserver.conf" \
				--backtitle $backtitle \
				--insecure \
				--passwordbox "\nContraseña de MySQL: " 10 51 2>&1 >/dev/tty)
				sed -e "s/sqlpass/$conf4/g" -i $server_tricore/etc/authserver.temp

				conf5=$(dialog --title "CONFIGURACIÓN DEL authserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nNombre de la base de datos Autentificación: \nValor por defecto $auth" 10 51 $auth 2>&1 >/dev/tty)
				sed -e "s/dbauth/$conf5/g" -i $server_tricore/etc/authserver.temp

				# PidFile = "auth.pid" NO TOCAR!!! IMPRESCINDIBLE.
				sed -e "s/PidFile = \"\"/PidFile = \"auth.pid\"/g" -i $server_tricore/etc/authserver.temp

				cp $server_tricore/etc/authserver.temp $server_tricore/etc/authserver.conf

				rm -f $server_tricore/etc/authserver.temp
				dialog --title "INFORMACIÓN" \
				--backtitle $backtitle \
				--msgbox "\nHas configurado el archivo authserver.conf.\n\nSi los valores que has introducido son correctos ya puedes arrancar el servidor de logueo." 10 50
				clear


####################################################################
# Configurar Worldserver.conf
####################################################################
			elif [ "$opcion56" = "2 - Configurar archivo worldserver.conf" ]; then
				if [ ! -x $server_tricore/etc/world.conf  ];then
					rm -f $server_tricore/etc/world.conf
				fi
				cp $server_tricore/etc/worldserver.conf.dist $server_tricore/etc/world.conf
				sed -e "s/LoginDatabaseInfo     = \"127\.0\.0\.1;3306;trinity;trinity;auth\"/LoginDatabaseInfo     = \"127\.0\.0\.1;3306;sqluser;sqlpass;dbauth\"/g" -i $server_tricore/etc/world.conf
				sed -e "s/WorldDatabaseInfo     = \"127\.0\.0\.1;3306;trinity;trinity;world\"/WorldDatabaseInfo     = \"127\.0\.0\.1;3306;sqluser;sqlpass;dbworld\"/g" -i $server_tricore/etc/world.conf
				sed -e "s/CharacterDatabaseInfo = \"127\.0\.0\.1;3306;trinity;trinity;characters\"/CharacterDatabaseInfo = \"127\.0\.0\.1;3306;sqluser;sqlpass;dbchar\"/g" -i $server_tricore/etc/world.conf

				conf6=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 1/42\n\nDirectorio del archivo data: \nValor por defecto data" 12 51 data 2>&1 >/dev/tty)
				sed -e "s/DataDir = \"\.\"/DataDir = \"\.\.\/$conf6\"/g" -i $server_tricore/etc/world.conf

				conf7=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 2/42\n\nDirectorio del archivo logs: \nValor por defecto logs" 12 51 logs 2>&1 >/dev/tty)
				sed -e "s/LogsDir = \"\"/LogsDir = \"\.\.\/$conf7\"/g" -i $server_tricore/etc/world.conf

				conf8=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 3/42\n\nUsuario de MySQL: \nValor por defecto root" 12 51 root 2>&1 >/dev/tty)
				sed -e "s/sqluser/$conf8/g" -i $server_tricore/etc/world.conf

				conf9=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--insecure \
				--passwordbox "\nOpción 4/42\n\nContraseña de MySQL: " 12 51 2>&1 >/dev/tty)
				sed -e "s/sqlpass/$conf9/g" -i $server_tricore/etc/world.conf

				conf10=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 5/42\n\nNombre de la base de datos Autentificación: \nValor por defecto $auth" 12 51 $auth 2>&1 >/dev/tty)
				sed -e "s/dbauth/$conf10/g" -i $server_tricore/etc/world.conf

				conf11=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 6/42\n\nNombre de la base de datos del World: \nValor por defecto $world" 12 51 $world 2>&1 >/dev/tty)
				sed -e "s/dbworld/$conf11/g" -i $server_tricore/etc/world.conf

				conf12=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 7/42\n\nNombre de la base de datos de Characters: \nValor por defecto $char" 12 51 $char 2>&1 >/dev/tty)
				sed -e "s/dbchar/$conf12/g" -i $server_tricore/etc/world.conf

				conf13=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 8/42\n\nPuerto de conexión al worldserver: \nValor por defecto 8085" 12 51 8085 2>&1 >/dev/tty)
				sed -e "s/WorldServerPort = 8085/WorldServerPort = $conf13/g" -i $server_tricore/etc/world.conf

				conf14=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 9/42\n\nLímite de jugadores conectados simultaneamente.\nSi escribimos 0 no hay límite de conectados.\nValor por defecto 100" 12 51 100 2>&1 >/dev/tty)
				sed -e "s/PlayerLimit = 0/PlayerLimit = $conf14/g" -i $server_tricore/etc/world.conf

				dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nOpción 13/42\n\nTipo de Reino - Quieres un reino PVP o Normal?\nEn los reinos normales se puede desconetar que los de la facción contraria te puedan atacer. En los PVP te pueden atacar menos en los santuarios.\n\n\n\n" 20 80 4 \
				"1 - Reino PVP" "" \
				"2 - Reino Normal" "" 2> conf16
				conf16=$(cat conf16)
				if [ "$conf16" = "1 - Reino PVP" ]; then
					sed -e "s/GameType = 0/GameType = 1/g" -i $server_tricore/etc/world.conf
				else
					sed -e "s/GameType = 0/GameType = 0/g" -i $server_tricore/etc/world.conf
				fi
				rm conf16

				#RESERVADO

				dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--yesno "\nOpción 15/42\n\n¿Quieres que se anuncien por taberna los eventos automáticos?" 12 51
				if [ $? = 0 ]; then
					sed -e "s/Event.Announce = 0/Event.Announce = 1/g" -i $server_tricore/etc/world.conf
				fi

				dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--yesno "\nOpción 18/42\n\n¿Quieres que los Alianzas y los Hordas se puedan comunicar por los canales de chat como taberna o \"decir\"?" 12 51
				if [ $? = 0 ]; then
					sed -e "s/AllowTwoSide.Interaction.Channel = 0/AllowTwoSide.Interaction.Channel = 1/g" -i $server_tricore/etc/world.conf
				fi

				dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--yesno "\nOpción 19/42\n\n¿Quieres que se puedan crear grupos mixtos entre Hordas y Alianzas?\nEsto es útil para cuando hay poca población en el servidor poder hacer mazmorras o raids conjuntamente." 12 51
				if [ $? = 0 ]; then
					sed -e "s/AllowTwoSide.Interaction.Group = 0/AllowTwoSide.Interaction.Group = 1/g" -i $server_tricore/etc/world.conf
				fi

				dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--yesno "\nOpción 20/42\n\n¿Quieres que se pueda interactuar en las subastas entre Hordas y Alianzas?\nEsto es útil para cuando hay poca población en el servidor." 12 51
				if [ $? = 0 ]; then
					sed -e "s/AllowTwoSide.Interaction.Auction = 0/AllowTwoSide.Interaction.Auction = 1/g" -i $server_tricore/etc/world.conf
				fi

				dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--yesno "\nOpción 22/42\n\n¿Quieres que se pueda comerciar con la facción contraria?." 12 51
				if [ $? = 0 ]; then
					sed -e "s/AllowTwoSide.Trade = 0/AllowTwoSide.Trade = 1/g" -i $server_tricore/etc/world.conf
				fi

				dialog --title "INFORMACIÓN" \
				--backtitle $backtitle \
				--msgbox "\nOpción 23/42\n\nRATES DEL SERVIDOR:\n\nLos rates son lo que determinan lo rápido que se avanza en el juego.\nLos servidores de Blizzard tienen un rate de x1 por lo que si nosotros ponemos rates x3 se multiplican los valores al triple.\nEjemplo: Ponemos rates de experiencia al matar bichos x3. Si al nivel 10 para subir al 11 debemos matar 30 zebras en el de Blizzard, al nuestro con 10 ya sería suficiente." 22 60
				clear

				conf17=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 24/42\n\nRATES DEL SERVIDOR:\nRates de objetos mediocres(grises)" 12 51 1 2>&1 >/dev/tty)
				sed -e "s/Rate.Drop.Item.Poor             = 1/Rate.Drop.Item.Poor             = $conf17/g" -i $server_tricore/etc/world.conf

				conf18=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 25/42\n\nRATES DEL SERVIDOR:\nRates de objetos normales(blancos)" 12 51 1 2>&1 >/dev/tty)
				sed -e "s/Rate.Drop.Item.Normal           = 1/Rate.Drop.Item.Normal           = $conf18/g" -i $server_tricore/etc/world.conf

				conf19=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 26/42\n\nRATES DEL SERVIDOR:\nRates de objetos poco frecuentes(verdes)" 12 51 1 2>&1 >/dev/tty)
				sed -e "s/Rate.Drop.Item.Uncommon         = 1/Rate.Drop.Item.Uncommon         = $conf19/g" -i $server_tricore/etc/world.conf

				conf20=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 27/42\n\nRATES DEL SERVIDOR:\nRates de objetos raros(azules)" 12 51 1 2>&1 >/dev/tty)
				sed -e "s/Rate.Drop.Item.Rare             = 1/Rate.Drop.Item.Rare             = $conf20/g" -i $server_tricore/etc/world.conf

				conf21=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 28/42\n\nRATES DEL SERVIDOR:\nRates de objetos épicos(morados)" 12 51 1 2>&1 >/dev/tty)
				sed -e "s/Rate.Drop.Item.Epic             = 1/Rate.Drop.Item.Epic             = $conf21/g" -i $server_tricore/etc/world.conf

				conf22=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 29/42\n\nRATES DEL SERVIDOR:\nRates de objetos legendarios(anaranjados)" 12 51 1 2>&1 >/dev/tty)
				sed -e "s/Rate.Drop.Item.Legendary        = 1/Rate.Drop.Item.Legendary        = $conf22/g" -i $server_tricore/etc/world.conf

				conf23=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 30/42\n\nRATES DEL SERVIDOR:\nRates de objetos artefactos" 12 51 1 2>&1 >/dev/tty)
				sed -e "s/Rate.Drop.Item.Artifact         = 1/Rate.Drop.Item.Artifact         = $conf23/g" -i $server_tricore/etc/world.conf

				conf24=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 31/42\n\nRATES DEL SERVIDOR:\nRates de objetos de misión" 12 51 1 2>&1 >/dev/tty)
				sed -e "s/Rate.Drop.Item.ReferencedAmount = 1/Rate.Drop.Item.ReferencedAmount = $conf24/g" -i $server_tricore/etc/world.conf

				conf25=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 32/42\n\nRATES DEL SERVIDOR:\nRates de dinero" 12 51 1 2>&1 >/dev/tty)
				sed -e "s/Rate.Drop.Money                 = 1/Rate.Drop.Money                 = $conf25/g" -i $server_tricore/etc/world.conf

				conf26=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 33/42\n\nRATES DEL SERVIDOR:\nRates experiencia por muertes" 12 51 1 2>&1 >/dev/tty)
				sed -e "s/Rate.XP.Kill    = 1/Rate.XP.Kill    = $conf26/g" -i $server_tricore/etc/world.conf

				conf27=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 34/42\n\nRATES DEL SERVIDOR:\nRates experiencia en misiones" 12 51 1 2>&1 >/dev/tty)
				sed -e "s/Rate.XP.Quest   = 1/Rate.XP.Quest   = $conf27/g" -i $server_tricore/etc/world.conf

				conf28=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--inputbox "\nOpción 35/42\n\nRATES DEL SERVIDOR:\nRates experiencia por exploración" 12 51 1 2>&1 >/dev/tty)
				sed -e "s/Rate.XP.Explore = 1/Rate.XP.Explore = $conf28/g" -i $server_tricore/etc/world.conf

				dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--yesno "\nOpción 36/42\n\n¿Quieres que se anuncie por canal global cuando se anote alguien a BG?\nEsto es útil para cuando hay poca población en el servidor." 12 51
				if [ $? = 0 ]; then
					sed -e "s/Battleground.QueueAnnouncer.Enable = 0/Battleground.QueueAnnouncer.Enable = 1/g" -i $server_tricore/etc/world.conf
				fi

				# RESERVADO

				dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--yesno "\nOpción 39/42\n\n¿Quieres que se adjudiquen los puntos de arenas automáticamente cada semana? Es recomendable que sí." 12 51
				if [ $? = 0 ]; then
					sed -e "s/Arena.AutoDistributePoints = 0/Arena.AutoDistributePoints = 1/g" -i $server_tricore/etc/world.conf
				fi

				dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--yesno "\nOpción 40/42\n\n¿Quieres que se anuncie por canal global cuando se anote un grupo a arenas?\nEsto es útil para cuando hay poca población en el servidor." 12 51
				if [ $? = 0 ]; then
					sed -e "s/Arena.QueueAnnouncer.Enable = 0/Arena.QueueAnnouncer.Enable = 1/g" -i $server_tricore/etc/world.conf
				fi

				dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
				--backtitle $backtitle \
				--yesno "\nOpción 41/42\n\n¿Deseas activar el acceso a la máquina por telnet?\nEsto es necesario si quieres tener una tienda de artículos en la web o gestionar el servidor remotamente." 12 51
				if [ $? = 0 ]; then
					sed -e "s/Ra.Enable = 0/Ra.Enable = 1/g" -i $server_tricore/etc/world.conf
				fi

				### Configuraciones que cambiamos automáticamente:

				sed -e "s/Motd = \"Welcome to a Trinity Core server.\"/Motd = \"Bienvenido a nuestro servidor.@Esperamos que sea de tu agrado.\"/g" -i $server_tricore/etc/world.conf

				#PidFile = "world.pid"  IMPRESCINDIBLE!!! NO TOCAR.  
				sed -e "s/PidFile = \"\"/PidFile = \"world.pid\"/g" -i $server_tricore/etc/world.conf

				cp $server_tricore/etc/world.conf $server_tricore/etc/worldserver.conf
				rm -f $server_tricore/etc/world.conf
				dialog --title "INFORMACIÓN" \
				--backtitle $backtitle \
				--msgbox "\nHas configurado el archivo worldserver.conf.\n\nSi los valores que has introducido son correctos ya puedes arrancar el servidor del juego." 10 50
				clear
			fi


########  CONCLUSIÓN MENÚ Configurar authserver.conf y worldserver.conf  ########
			dialog --title "Menú de opciones --- Creado por MSANCHO" \
			--backtitle $backtitle \
			--nocancel \
			--menu "\nConfigurar authserver.conf y worldserver.conf" 20 80 8 \
			"1 - Configurar archivo authserver.conf" "" \
			"2 - Configurar archivo worldserver.conf" "" \
			"0 - Volver" "" 2> ~/var56
		  
			opcion56=$(cat ~/var56)
			rm ~/var56
			done
		fi


########  CONCLUSIÓN MENÚ 7  ########
		dialog --title "Menú de opciones --- Creado por MSANCHO" \
		--backtitle $backtitle \
		--nocancel \
		--menu "\nConfiguraciones varias" 20 80 8 \
		"1 - Configurar tabla realmlist de la base de datos auth" "" \
		"2 - Configurar authserver.conf y worldserver.conf" "" \
		"0 - Volver" "" 2> var55
		  
		opcion55=$(cat var55)
		rm var55
		done
	fi


########  CONCLUSIÓN MENÚ Trinitycore versión 3.3.5a (12340)  ######## 
	dialog --title "Menú de opciones --- Creado por MSANCHO" \
	--backtitle $backtitle \
	--nocancel \
	--menu "\nOpciones disponibles:" 20 80 11 \
	"1 - Obtención o actualización de todos los archivos necesarios" "" \
	"2 - Compilar el emulador" "" \
	"3 - DBC's, maps y vmaps - Descarga y colocación en directorio" "" \
	"4 - Instalar las Bases de Datos" "" \
	"6 - Configuraciones varias" "" \
	"0 - Salir de la aplicación" "" 2> ~/var50
	  
	opcion50=$(cat ~/var50)
	if [ "$opcion50" = "0 - Salir de la aplicación" ]; then
		rm ~/var*
		dialog --title "Menú de opciones --- Creado por MSANCHO" \
		--backtitle $backtitle \
		--msgbox "\nGracias por usar el script de instalación." 10 50
		exit
	fi
	done


fi

#####################################################################################################
# FINAL Menú de emuladores disponibles
#####################################################################################################
dialog --title "Menú de opciones --- Creado por MSANCHO" \
--backtitle $backtitle \
--nocancel \
--menu "\nEmulador que deseas compilar:" 20 80 11 \
"i - Información - Guía de uso" "" \
"1 - Instalar programas preparación - esenciales" "" \
"4 - Trinitycore versión 3.3.5a (12340)" "" \
"5 - PRÓXIMAMENTE - Conexión por Telnet a nuestro servidor" "" \
"6 - PRÓXIMAMENTE - Copias de seguridad de las Bases de Datos" "" \
"9 - PRÓXIMAMENTE - Crea tu web de registro de cuentas" "" \
"0 - Salir de la aplicación" "" 2> ~/var0
	  
opcion0=$(cat ~/var0)

if [ "$opcion0" = "0 - Salir de la aplicación" ]; then
	rm ~/var*
	dialog --title "Menú de opciones --- Creado por MSANCHO" \
	--backtitle $backtitle \
	--msgbox "\nGracias por usar el script de instalación." 10 50
	clear
fi
done