#!/bin/bash

if [ ! -x /usr/bin/dialog  ];then
	clear
	echo "Parece que no tienes DIALOG instalado.
	Vamos a instalarlo para poder continuar"
	sudo apt-get install dialog
fi
	printf "\e[8;35;135;t"
	clear
	dialog --title "INFORMACIÓN" \
	--backtitle https://catlinux.es \
	--msgbox "\nEstos datos son necesarios para la conexión a la base de datos y para poder compilar sin problemas. \nPon valores que sean coherentes o de lo contrario no funcionará correctamente el script." 10 70 && clear

####################################################################
# VARIABLES 
####################################################################


backtitle="https://catlinux.es"
soft="build-essential expect git git-core clang cmake make gcc g++ automake autoconf patch libmariadbclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev mariadb-server p7zip-full default-libmysqlclient-dev libace-6.* libace-dev libtool grep binutils zlibc libc6 subversion wget tmux"
repos=$HOME/Repos
servers=$HOME/Servers
repo_tc335="-b 3.3.5 git://github.com/TrinityCore/TrinityCore.git"
repo_ac335="https://github.com/azerothcore/azerothcore-wotlk.git --branch master --single-branch"
repo_vmangos="https://github.com/vmangos/core.git"
db_tc335=https://github.com/TrinityCore/TrinityCore/releases/download/TDB335.20101/TDB_full_world_335.20101_2020_10_15.7z
db_vmangos=https://github.com/tortosi/brotalnia_database/releases/download/10-2019/world_full_05_october_2019.7z
link_data_tc335=https://arxius.tronosdesangre.es/index.php/s/YJWw6m9EWF52mAe
link_data_ac=https://arxius.tronosdesangre.es/index.php/s/Had9DKpfkpT4q7k
link_data_vmangos=https://arxius.tronosdesangre.es/index.php/s/HfN7GaztcC7p5oY
server_tc335=$HOME/Servers/TC355
server_ac335=$HOME/Servers/AC355
server_vmangos=$HOME/Servers/vmangos
repoLoc_tc335=$HOME/Repos/TC335
repoLoc_ac335=$HOME/Repos/AC335
repoLoc_vmangos=$HOME/Repos/vmangos
repoLoc_db_vmangos=$HOME/Repos/brotalnia_database
sql_ac_base=$repoLoc_ac335/data/sql/base
sql_ac_updates=$repoLoc_ac335/data/sql/updates
ipLocal=$(ip addr show |grep 'inet '|grep -v 127.0.0.1 |awk '{print $2}'| cut -d/ -f1)
# OBTENGO NOMBRE DE ACHIVO COMPRIMIDO DE BASE DE DATOS
arch_comp_db_tc335=$(basename "$db_tc335")
arch_comp_db_vmangos=$(basename "$db_vmangos")
# OBTENGO NOMBRE DE ACHIVO SQL
arch_sql_db_tc335=${arch_comp_db_tc335%.*}.sql
arch_sql_db_vmangos=${arch_comp_db_vmangos%.*}.sql


####################################################################
# Opciones de configuración
####################################################################

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
--inputbox "\nDirección IP host de Base de Dados: \nValor por defecto localhost" 10 51 localhost 2>&1 >/dev/tty)

port=$(dialog --title "DATOS DE CONEXIÓN" \
--backtitle $backtitle \
--nocancel \
--inputbox "\nPuerto de MySQL: \nValor por defecto 3306" 10 51 3306 2>&1 >/dev/tty)

user=$(dialog --title "DATOS DE CONEXIÓN" \
--backtitle $backtitle \
--nocancel \
--inputbox "\nUsuario de MySQL: \nValor por defecto master" 10 51 master 2>&1 >/dev/tty)

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
# Menú principal
#####################################################################################################
dialog --title "Menú de opciones --- Creado por MSANCHO" \
--backtitle $backtitle \
--nocancel \
--menu "\nMenú principal:" 20 80 11 \
"i - Información - Guía de uso" "" \
"1 - Preparación del sistema - Esenciales" "" \
"2 - Emuladores disponibles" "" \
"3 - Copias de seguridad de las Bases de Datos - PRÓXIMAMENTE" "" \
"4 - Conexión por Telnet a nuestro servidor - PRÓXIMAMENTE" "" \
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
# i - Información - Guía de uso
####################################################################
	if [ "$opcion0" = "i - Información - Guía de uso" ]; then
		dialog --title "Menú de opciones --- Creado por MSANCHO" \
		--backtitle $backtitle \
		--nocancel \
		--menu "\nGuía de uso" 20 60 8 \
		"1 - Leer en pantalla" "" \
		"2 - Guardar como archivo" "" \
		"0 - Volver" "" 2> ~/vari
	  
		opcioni=$(cat ~/vari)
		rm ~/var*

		while [ "$opcioni" != "0 - Volver" ]; do

####################################################################
# Leer en pantalla
####################################################################
		if [ "$opcioni" = "1 - Leer en pantalla" ]; then
			clear
			cd ~/ && wget https://raw.githubusercontent.com/tortosi/InstalaEmulador/master/manual
			dialog --textbox manual 40 135
			rm ~/manual*

####################################################################
# Guardar como archivo
####################################################################
		elif [ "$opcioni" = "2 - Guardar como archivo" ]; then
			clear
			cd ~/Documentos && wget https://raw.githubusercontent.com/tortosi/InstalaEmulador/master/manual
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
		"0 - Volver" "" 2> ~/vari
	  
		opcioni=$(cat ~/vari)
		rm ~/var*
		done
	fi

####################################################################
# 1 - Preparación del sistema - Esenciales
####################################################################
	if [ "$opcion0" = "1 - Preparación del sistema - Esenciales" ]; then
		dialog --title "Menú de opciones --- Creado por MSANCHO" \
		--backtitle $backtitle \
		--nocancel \
		--menu "\nPreparación del sistema - Esenciales" 20 60 8 \
		"1 - Instalar programas y librerías" "" \
		"2 - Crear usuario base de datos" "" \
		"0 - Volver" "" 2> ~/var1
	  
		opcion1=$(cat ~/var1)
		rm ~/var*

		while [ "$opcion1" != "0 - Volver" ]; do

####################################################################
# 1 - Instalar programas preparación - esenciales
####################################################################
		if [ "$opcion1" = "1 - Instalar programas y librerías" ]; then
			dialog --title "INFORMACIÓN" \
			--backtitle $backtitle \
			--nocancel \
			--msgbox "\nProcedemos a instalar los programas necesarios para recibir los repositorios, bases de datos, MySQL, apache2, compilar, librerías necesarias, etc...\n\nEste proceso puede demorar unos 5 minutos o más, dependiendo de tu equipo.\n\nProbablemete te pida algún dato para las configuraciones de MySQL." 14 70
			clear && sudo apt-get install $soft -y
			sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
			sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
	
			# AJUSTES DE MARIADB

			sudo mysql -u root -p${pass} --port=${port} <<_EOF_
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
# Menú - Crear usuario de mysql
#####################################################################################################
		elif [ "$opcion1" = "2 - Crear usuario base de datos" ]; then
			dialog --title "INFORMACIÓN" \
			--backtitle $backtitle \
			--msgbox "\nVamos a crear tu usuario de mysql para utilizar con las bases de datos del juego. El usuario que se creará será el siguiente: \nUsuario: $user \nContraseña: $pass \n" 10 70 
			clear
			test_user=`mysql -uroot -p${pass} --port=${port} -e "select User from mysql.user" | grep $user`
    		if [ "$test_user" == "$user" ]; then
       			dialog --title "INFORMACIÓN" \
				--backtitle $backtitle \
				--msgbox "\nEl usuario $user ya se creó con anterioridad en la tabla user de tus bases de datos.  \n" 10 70 
				clear
    		else
       		mysql -u root -p${pass} --port=${port}  <<_EOF_
			CREATE USER ${user}@localhost IDENTIFIED BY '${pass}';
			GRANT ALL PRIVILEGES ON *.* TO '${user}'@'localhost';
			FLUSH PRIVILEGES;
_EOF_
    		fi
		fi	

########  CONCLUSIÓN MENÚ Preparación del sistema - Esenciales  ######## 
		dialog --title "Menú de opciones --- Creado por MSANCHO" \
		--backtitle $backtitle \
		--nocancel \
		--menu "\nPreparación del sistema - Esenciales" 20 60 8 \
		"1 - Instalar programas y librerías" "" \
		"2 - Crear usuario base de datos" "" \
		"0 - Volver" "" 2> ~/var1
	  
		opcion1=$(cat ~/var1)
		rm ~/var*
		done
	fi

####################################################################
# 2 - Emuladores disponibles
####################################################################
	if [ "$opcion0" = "2 - Emuladores disponibles" ]; then
		dialog --title "Menú de opciones --- Creado por MSANCHO" \
		--backtitle $backtitle \
		--nocancel \
		--menu "\nEmuladores disponibles" 20 60 8 \
		"1 - TrinityCore WotLK 3.3.5" "" \
		"2 - AzerothCore WotLK 3.3.5" "" \
		"3 - Vanilla MaNGOS 1.2/1.12" "" \
		"0 - Volver" "" 2> ~/var2
	  
		opcion2=$(cat ~/var2)
		rm ~/var*

		while [ "$opcion2" != "0 - Volver" ]; do


#####################################################################################################
# Menú - TrinityCore WotLK 3.3.5
#####################################################################################################
		if [ "$opcion2" = "1 - TrinityCore WotLK 3.3.5" ]; then
			dialog --title "Menú de opciones --- Creado por MSANCHO" \
			--backtitle $backtitle \
			--nocancel \
			--menu "\nOpciones disponibles:" 20 80 11 \
			"1 - Obtención o actualización de todos los archivos necesarios" "" \
			"2 - Compilar el emulador" "" \
			"3 - DBC's, maps y vmaps - Descarga y colocación en directorio" "" \
			"4 - Instalar las Bases de Datos" "" \
			"5 - Configuraciones varias" "" \
			"0 - Volver" "" 2> ~/var21
	  
			opcion21=$(cat ~/var21)
			rm ~/var*

			while [ "$opcion21" != "0 - Volver" ]; do

####################################################################
# Menú - Obtención o actualización de todos los archivos necesarios
####################################################################
			if [ "$opcion21" = "1 - Obtención o actualización de todos los archivos necesarios" ]; then
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nManejo de Repositorios y archivos" 20 60 8 \
				"1 - Descargar repositorios" "" \
				"2 - Actualizar repositorios" "" \
				"0 - Volver" "" 2> ~/var211
			  
				opcion211=$(cat ~/var211)
				rm ~/var*
	
				while [ "$opcion211" != "0 - Volver" ]; do


####################################################################
# Descargar repositorios
####################################################################
				if [ "$opcion211" = "1 - Descargar repositorios" ]; then
					clear
					if [ ! -x $HOME/Repos  ];then
						dialog --title "INFORMACIÓN" \
						--backtitle $backtitle \
						--pause "\nSe va a crear la carpeta de repositorios dentro de nuestro home" 10 50 5
						clear && cd $HOME/ && mkdir Repos
					fi
					if [ ! -x $HOME/Repos/TC335  ];then
						dialog --title "INFORMACIÓN" \
						--backtitle $backtitle \
						--pause "\nVamos a obtener los repositorios de TrinityCore" 10 50 5
						clear && cd $repos && git clone $repo_tc335 TC335
					else
						dialog --title "INFORMACIÓN" \
						--backtitle $backtitle \
						--msgbox "\nNo es necesario descargar el repositorio. Ya se encuentra en tu equipo. Puedes utlilizar la opción de actualizar repositorios." 14 50
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
				elif [ "$opcion211" = "2 - Actualizar repositorios" ]; then
					clear && cd $repoLoc_tc335 && git pull origin 3.3.5
					read -n 1 -s -r -p "Pulsa una tecla para continuar..." 
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--pause "\nRepositorios del core actualizados." 10 50 5
					clear
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nYa puedes recompilar el emulador de nuevo." 8 50
					clear
				fi


########  CONCLUSIÓN MENÚ Obtención o actualización de todos los archivos necesarios  ########  
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nManejo de Repositorios y archivos" 20 60 8 \
				"1 - Descargar repositorios" "" \
				"2 - Actualizar repositorios" "" \
				"0 - Volver" "" 2> ~/var211
		
				opcion211=$(cat ~/var211)
				rm ~/var*
				done


####################################################################
# Compilar el emulador
####################################################################
			elif [ "$opcion21" = "2 - Compilar el emulador" ]; then
				if [ ! -x $repoLoc_tc335/build  ];then
					cd $repoLoc_tc335 && mkdir build
				fi
				if [ ! -x $HOME/Servers  ];then
					cd $HOME && mkdir Servers
				fi
				cd $repoLoc_tc335/build  && clear
				cmake ../ -DCMAKE_INSTALL_PREFIX=$server_tc335 -DTOOLS=0
				make -j $(nproc) install
				read -n 1 -s -r -p "Pulsa una tecla para continuar..." 
				cp $HOME/Repos/TDB-335/$arch_sql_db_tc335 $server_tc335/bin
				dialog --title "INFORMACIÓN" \
				--backtitle $backtitle \
				--msgbox "\nHas terminado de compilar tu emulador. Si todo ha salido correctamete lo encontrarás en tu home, dentro de la carpeta Servers/server_tc335" 9 50
				clear

####################################################################
# DBC's, maps y vmaps - Descarga y colocación en directorio
####################################################################
			elif [ "$opcion21" = "3 - DBC's, maps y vmaps - Descarga y colocación en directorio" ]; then
				if [ ! -x $server_tc335/data  ];then
					clear && cd $server_tc335
					wget --no-check-certificate --content-disposition $link_data_tc335/download -O data_tc335.zip
					unzip data_tc335.zip && rm data_tc335.zip
					read -n 1 -s -r -p "Pulsa una tecla para continuar..." 
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

			elif [ "$opcion21" = "4 - Instalar las Bases de Datos" ]; then
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nInstalar las Bases de Datos" 20 80 8 \
				"1 - Crear las Bases de datos" "" \
				"2 - Poblar las Bases de datos" "" \
				"0 - Volver" "" 2> ~/var214

				opcion214=$(cat ~/var214)
				rm ~/var214
	
				while [ "$opcion214" != "0 - Volver" ]; do


####################################################################
# Instalar base de datos TDB
####################################################################
				if [ "$opcion214" = "1 - Crear las Bases de datos" ]; then
					dialog --title "ATENCIÓN!" \
					--backtitle $backtitle \
					--defaultno \
					--yesno "\nVas a eliminar cualquier base de datos que tenga los nombres ${world}, ${auth} y ${char} creándolas de nuevo con sus estructuras predeterminadas. ¿Estás seguro?" 10 50 
					if [ $? = 0 ]; then
							mysql -u${user} -p${pass} --port=${port} <<_EOF_
							CREATE DATABASE IF NOT EXISTS ${world} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
							CREATE DATABASE IF NOT EXISTS ${char} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
							CREATE DATABASE IF NOT EXISTS ${auth} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
							FLUSH PRIVILEGES;
_EOF_
						dialog --title "INFORMACIÓN" \
						--backtitle $backtitle \
						--msgbox "\nFinalizada la creación de las bases de datos ${world}, ${auth} y ${char}." 10 50
						clear
					fi


####################################################################
# Poblar las Bases de datos
####################################################################
				elif [ "$opcion214" = "2 - Poblar las Bases de datos" ]; then
					dialog --title "ATENCIÓN!" \
					--backtitle $backtitle \
					--msgbox "\nEn TrinityCore, la inyección de datos en las tablas ${world}, ${auth} y ${char} se hacen\nautomáticamente al arranar el emulador. De todos modos vamos a poblar en este moneto ${auth} para facilitar un proceso necesario." 14 50
					clear
					mysql -u${user} -p${pass} --port=${port} $auth < $repoLoc_tc335/sql/base/auth_database.sql
				fi


########  CONCLUSIÓN MENÚ Instalar las Bases de Datos  ######## 
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nInstalar las Bases de Datos" 20 80 8 \
				"1 - Crear las Bases de datos" "" \
				"2 - Poblar las Bases de datos" "" \
				"0 - Volver" "" 2> ~/var214
		  
				opcion214=$(cat ~/var214)
				rm ~/var214
				done


####################################################################
# Configuraciones varias
####################################################################
			elif [ "$opcion21" = "5 - Configuraciones varias" ]; then
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nConfiguraciones varias" 20 80 8 \
				"1 - Configurar authserver.conf" "" \
				"2 - Configurar worldserver.conf" "" \
				"3 - Configurar tabla realmlist de la base de datos auth" "" \
				"0 - Volver" "" 2> var215
		  
				opcion215=$(cat var215)
				rm var215

				while [ "$opcion215" != "0 - Volver" ]; do


####################################################################
# Configurar Authserver.conf
####################################################################
				if [ "$opcion215" = "1 - Configurar authserver.conf" ]; then
					if [ ! -x $server_tc335/etc/authserver.temp  ];then
						rm -f $server_tc335/etc/authserver.temp
					fi
					cp $server_tc335/etc/authserver.conf.dist $server_tc335/etc/authserver.temp

					sed -e "s/LoginDatabaseInfo = \"127\.0\.0\.1;3306;trinity;trinity;auth\"/LoginDatabaseInfo = \"127\.0\.0\.1;port;sqluser;sqlpass;dbauth\"/g" -i $server_tc335/etc/authserver.temp

					conf=$(dialog --title "CONFIGURACIÓN DEL authserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nDirectorio del archivo logs: \nValor por defecto logs" 10 51 logs 2>&1 >/dev/tty)
					sed -e "s/LogsDir = \"\"/LogsDir = \"\.\.\/$conf\"/g" -i $server_tc335/etc/authserver.temp
					if [ ! -x $server_tc335/$conf  ];then
						mkdir $server_tc335/$conf
					fi

					sed -e "s/port/$port/g" -i $server_tc335/etc/authserver.temp

					sed -e "s/sqluser/$user/g" -i $server_tc335/etc/authserver.temp

					sed -e "s/sqlpass/$pass/g" -i $server_tc335/etc/authserver.temp

					sed -e "s/dbauth/$auth/g" -i $server_tc335/etc/authserver.temp

					# PidFile = "auth.pid" NO TOCAR!!! IMPRESCINDIBLE.
					sed -e "s/PidFile = \"\"/PidFile = \"auth.pid\"/g" -i $server_tc335/etc/authserver.temp

					cp $server_tc335/etc/authserver.temp $server_tc335/etc/authserver.conf

					rm -f $server_tc335/etc/authserver.temp
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nEl resto de valores se han configurado automáticamente con los datos que has introducido al arrancar el script. Ya puedes arrancar el servidor de logueo." 10 50
					clear


####################################################################
# Configurar Worldserver.conf
####################################################################
				elif [ "$opcion215" = "2 - Configurar worldserver.conf" ]; then
					if [ ! -x $server_tc335/etc/world.conf  ];then
						rm -f $server_tc335/etc/world.conf
					fi
					cp $server_tc335/etc/worldserver.conf.dist $server_tc335/etc/world.conf
					sed -e "s/LoginDatabaseInfo     = \"127\.0\.0\.1;3306;trinity;trinity;auth\"/LoginDatabaseInfo     = \"127\.0\.0\.1;port;sqluser;sqlpass;dbauth\"/g" -i $server_tc335/etc/world.conf
					sed -e "s/WorldDatabaseInfo     = \"127\.0\.0\.1;3306;trinity;trinity;world\"/WorldDatabaseInfo     = \"127\.0\.0\.1;port;sqluser;sqlpass;dbworld\"/g" -i $server_tc335/etc/world.conf
					sed -e "s/CharacterDatabaseInfo = \"127\.0\.0\.1;3306;trinity;trinity;characters\"/CharacterDatabaseInfo = \"127\.0\.0\.1;port;sqluser;sqlpass;dbchar\"/g" -i $server_tc335/etc/world.conf

					conf6=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 1/27\n\nDirectorio del archivo data: \nValor por defecto data" 12 51 data 2>&1 >/dev/tty)
					sed -e "s/DataDir = \"\.\"/DataDir = \"\.\.\/$conf6\"/g" -i $server_tc335/etc/world.conf

					conf7=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 2/27\n\nDirectorio del archivo logs: \nValor por defecto logs" 12 51 logs 2>&1 >/dev/tty)
					sed -e "s/LogsDir = \"\"/LogsDir = \"\.\.\/$conf7\"/g" -i $server_tc335/etc/world.conf
					if [ ! -x $server_tc335/$conf7  ];then
						mkdir $server_tc335/$conf7
					fi

					sed -e "s/port/$port/g" -i $server_tc335/etc/world.conf

					sed -e "s/sqluser/$user/g" -i $server_tc335/etc/world.conf

					sed -e "s/sqlpass/$pass/g" -i $server_tc335/etc/world.conf

					sed -e "s/dbauth/$auth/g" -i $server_tc335/etc/world.conf

					sed -e "s/dbworld/$world/g" -i $server_tc335/etc/world.conf

					sed -e "s/dbchar/$char/g" -i $server_tc335/etc/world.conf

					conf13=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 3/27\n\nPuerto de conexión al worldserver: \nValor por defecto 8085" 12 51 8085 2>&1 >/dev/tty)
					sed -e "s/WorldServerPort = 8085/WorldServerPort = $conf13/g" -i $server_tc335/etc/world.conf

					conf14=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 4/27\n\nLímite de jugadores conectados simultaneamente.\nSi escribimos 0 no hay límite de conectados.\nValor por defecto 100" 12 51 100 2>&1 >/dev/tty)
					sed -e "s/PlayerLimit = 0/PlayerLimit = $conf14/g" -i $server_tc335/etc/world.conf

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--nocancel \
					--menu "\nOpción 5/27\n\nTipo de Reino - Quieres un reino PVP o Normal?\nEn los reinos normales se puede desconetar que los de la facción contraria te puedan atacer. En los PVP te pueden atacar menos en los santuarios.\n\n\n\n" 20 80 4 \
					"1 - Reino PVP" "" \
					"2 - Reino Normal" "" 2> conf16
					conf16=$(cat conf16)
					if [ "$conf16" = "1 - Reino PVP" ]; then
						sed -e "s/GameType = 0/GameType = 1/g" -i $server_tc335/etc/world.conf
					else
						sed -e "s/GameType = 0/GameType = 0/g" -i $server_tc335/etc/world.conf
					fi
					rm conf16

					#RESERVADO

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 6/27\n\n¿Quieres que se anuncien por taberna los eventos automáticos?" 12 51
					if [ $? = 0 ]; then
						sed -e "s/Event.Announce = 0/Event.Announce = 1/g" -i $server_tc335/etc/world.conf
					fi

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 7/27\n\n¿Quieres que los Alianzas y los Hordas se puedan comunicar por los canales de chat como taberna o \"decir\"?" 12 51
					if [ $? = 0 ]; then
						sed -e "s/AllowTwoSide.Interaction.Channel = 0/AllowTwoSide.Interaction.Channel = 1/g" -i $server_tc335/etc/world.conf
					fi

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 8/27\n\n¿Quieres que se puedan crear grupos mixtos entre Hordas y Alianzas?\nEsto es útil para cuando hay poca población en el servidor poder hacer mazmorras o raids conjuntamente." 12 51
					if [ $? = 0 ]; then
						sed -e "s/AllowTwoSide.Interaction.Group = 0/AllowTwoSide.Interaction.Group = 1/g" -i $server_tc335/etc/world.conf
					fi

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 9/27\n\n¿Quieres que se pueda interactuar en las subastas entre Hordas y Alianzas?\nEsto es útil para cuando hay poca población en el servidor." 12 51
					if [ $? = 0 ]; then
						sed -e "s/AllowTwoSide.Interaction.Auction = 0/AllowTwoSide.Interaction.Auction = 1/g" -i $server_tc335/etc/world.conf
					fi

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 10/27\n\n¿Quieres que se pueda comerciar con la facción contraria?." 12 51
					if [ $? = 0 ]; then
						sed -e "s/AllowTwoSide.Trade = 0/AllowTwoSide.Trade = 1/g" -i $server_tc335/etc/world.conf
					fi

					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nOpción 11/27\n\nRATES DEL SERVIDOR:\n\nLos rates son lo que determinan lo rápido que se avanza en el juego.\nLos servidores de Blizzard tienen un rate de x1 por lo que si nosotros ponemos rates x3 se multiplican los valores al triple.\nEjemplo: Ponemos rates de experiencia al matar bichos x3. Si al nivel 10 para subir al 11 debemos matar 30 zebras en el de Blizzard, al nuestro con 10 ya sería suficiente." 22 60
					clear

					conf17=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 12/27\n\nRATES DEL SERVIDOR:\nRates de objetos mediocres(grises)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Poor             = 1/Rate.Drop.Item.Poor             = $conf17/g" -i $server_tc335/etc/world.conf

					conf18=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 13/27\n\nRATES DEL SERVIDOR:\nRates de objetos normales(blancos)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Normal           = 1/Rate.Drop.Item.Normal           = $conf18/g" -i $server_tc335/etc/world.conf

					conf19=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 14/27\n\nRATES DEL SERVIDOR:\nRates de objetos poco frecuentes(verdes)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Uncommon         = 1/Rate.Drop.Item.Uncommon         = $conf19/g" -i $server_tc335/etc/world.conf

					conf20=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 15/27\n\nRATES DEL SERVIDOR:\nRates de objetos raros(azules)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Rare             = 1/Rate.Drop.Item.Rare             = $conf20/g" -i $server_tc335/etc/world.conf

					conf21=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 16/27\n\nRATES DEL SERVIDOR:\nRates de objetos épicos(morados)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Epic             = 1/Rate.Drop.Item.Epic             = $conf21/g" -i $server_tc335/etc/world.conf

					conf22=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 17/27\n\nRATES DEL SERVIDOR:\nRates de objetos legendarios(anaranjados)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Legendary        = 1/Rate.Drop.Item.Legendary        = $conf22/g" -i $server_tc335/etc/world.conf

					conf23=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 18/27\n\nRATES DEL SERVIDOR:\nRates de objetos artefactos" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Artifact         = 1/Rate.Drop.Item.Artifact         = $conf23/g" -i $server_tc335/etc/world.conf

					conf24=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 19/27\n\nRATES DEL SERVIDOR:\nRates de objetos de misión" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.ReferencedAmount = 1/Rate.Drop.Item.ReferencedAmount = $conf24/g" -i $server_tc335/etc/world.conf

					conf25=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 20/27\n\nRATES DEL SERVIDOR:\nRates de dinero" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Money                 = 1/Rate.Drop.Money                 = $conf25/g" -i $server_tc335/etc/world.conf

					conf26=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 21/27\n\nRATES DEL SERVIDOR:\nRates experiencia por muertes" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.XP.Kill    = 1/Rate.XP.Kill    = $conf26/g" -i $server_tc335/etc/world.conf

					conf27=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 22/27\n\nRATES DEL SERVIDOR:\nRates experiencia en misiones" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.XP.Quest   = 1/Rate.XP.Quest   = $conf27/g" -i $server_tc335/etc/world.conf

					conf28=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 23/27\n\nRATES DEL SERVIDOR:\nRates experiencia por exploración" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.XP.Explore = 1/Rate.XP.Explore = $conf28/g" -i $server_tc335/etc/world.conf

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 24/27\n\n¿Quieres que se anuncie por canal global cuando se anote alguien a BG?\nEsto es útil para cuando hay poca población en el servidor." 12 51
					if [ $? = 0 ]; then
						sed -e "s/Battleground.QueueAnnouncer.Enable = 0/Battleground.QueueAnnouncer.Enable = 1/g" -i $server_tc335/etc/world.conf
					fi

					# RESERVADO

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 25/27\n\n¿Quieres que se adjudiquen los puntos de arenas automáticamente cada semana? Es recomendable que sí." 12 51
					if [ $? = 0 ]; then
						sed -e "s/Arena.AutoDistributePoints = 0/Arena.AutoDistributePoints = 1/g" -i $server_tc335/etc/world.conf
					fi

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 26/27\n\n¿Quieres que se anuncie por canal global cuando se anote un grupo a arenas?\nEsto es útil para cuando hay poca población en el servidor." 12 51
					if [ $? = 0 ]; then
						sed -e "s/Arena.QueueAnnouncer.Enable = 0/Arena.QueueAnnouncer.Enable = 1/g" -i $server_tc335/etc/world.conf
					fi

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 27/27\n\n¿Deseas activar el acceso a la máquina por telnet?\nEsto es necesario si quieres tener una tienda de artículos en la web o gestionar el servidor remotamente." 12 51
					if [ $? = 0 ]; then
						sed -e "s/Ra.Enable = 0/Ra.Enable = 1/g" -i $server_tc335/etc/world.conf
					fi

					### Configuraciones que cambiamos automáticamente:

					sed -e "s/Motd = \"Welcome to a Trinity Core server.\"/Motd = \"Bienvenido a nuestro servidor.@Esperamos que sea de tu agrado.\"/g" -i $server_tc335/etc/world.conf

					#PidFile = "world.pid"  IMPRESCINDIBLE!!! NO TOCAR.  
					sed -e "s/PidFile = \"\"/PidFile = \"world.pid\"/g" -i $server_tc335/etc/world.conf

					cp $server_tc335/etc/world.conf $server_tc335/etc/worldserver.conf
					rm -f $server_tc335/etc/world.conf
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nHas configurado el archivo worldserver.conf.\n\nSi los valores que has introducido son correctos ya puedes arrancar el servidor del juego." 10 50
					clear


####################################################################
# Configurar tabla realmlist de la base de datos auth
####################################################################
				elif [ "$opcion215" = "3 - Configurar tabla realmlist de la base de datos auth" ]; then
					rm -f $server_tc335/etc/confrealm.sql
					echo "REPLACE INTO \`realmlist\` (\`id\`,\`name\`,\`address\`,\`localAddress\`,\`port\`,\`icon\`,\`flag\`,\`timezone\`,\`allowedSecurityLevel\`,\`population\`,\`gamebuild\`) VALUES
(1,'NombreReino','addressReino','127.0.0.1',portReino,1,2,1,0,0,12340);" >> $server_tc335/etc/confrealm.sql
					
					conf1=$(dialog --title "CONFIGURACIÓN TABLA realmlist de la DB auth" \
					--backtitle $backtitle \
					--inputbox "\nNombre que le quieres dar a tu reino:" 10 51 Trinity 2>&1 >/dev/tty)
					sed -e "s/NombreReino/$conf1/g" -i $server_tc335/etc/confrealm.sql

					conf2=$(dialog --title "CONFIGURACIÓN TABLA realmlist de la DB auth" \
					--backtitle $backtitle \
					--inputbox "\nIp externa de conexión a tu servidor. Si lo ejecutas en local deja el valor predeterminado:" 10 51 127.0.0.1 2>&1 >/dev/tty)
					sed -e "s/addressReino/$conf2/g" -i $server_tc335/etc/confrealm.sql

					conf3=$(dialog --title "CONFIGURACIÓN TABLA realmlist de la DB auth" \
					--backtitle $backtitle \
					--inputbox "\nDirección LAN de tu servidor. IMPRESCINDIBLE:" 10 51 192.168.1.150 2>&1 >/dev/tty)
					sed -e "s/127.0.0.1/$conf3/g" -i $server_tc335/etc/confrealm.sql

					conf4=$(dialog --title "CONFIGURACIÓN TABLA realmlist de la DB auth" \
					--backtitle $backtitle \
					--inputbox "\nPuerto de conexión:" 10 51 8085 2>&1 >/dev/tty)
					sed -e "s/portReino/$conf4/g" -i $server_tc335/etc/confrealm.sql

					mysql -u${user} -p${pass} --port=${port} $auth < $server_tc335/etc/confrealm.sql
					rm -f $server_tc335/etc/confrealm.sql
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nYa tienes la Tabla realmlist configurada" 10 50
					clear
				fi

########  CONCLUSIÓN MENÚ Configuraciones varias  ########
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nConfiguraciones varias" 20 80 8 \
				"1 - Configurar authserver.conf" "" \
				"2 - Configurar worldserver.conf" "" \
				"3 - Configurar tabla realmlist de la base de datos auth" "" \
				"0 - Volver" "" 2> var215
		  
				opcion215=$(cat var215)
				rm var215
				done
			fi


########  CONCLUSIÓN MENÚ TrinityCore WotLK 3.3.5  ######## 
			dialog --title "Menú de opciones --- Creado por MSANCHO" \
			--backtitle $backtitle \
			--nocancel \
			--menu "\nOpciones disponibles:" 20 80 11 \
			"1 - Obtención o actualización de todos los archivos necesarios" "" \
			"2 - Compilar el emulador" "" \
			"3 - DBC's, maps y vmaps - Descarga y colocación en directorio" "" \
			"4 - Instalar las Bases de Datos" "" \
			"5 - Configuraciones varias" "" \
			"0 - Volver" "" 2> ~/var21
	  
			opcion21=$(cat ~/var21)
			rm ~/var*
			done
		fi


#####################################################################################################
# Menú - AzerothCore WotLK 3.3.5
#####################################################################################################
		if [ "$opcion2" = "2 - AzerothCore WotLK 3.3.5" ]; then
			dialog --title "Menú de opciones --- Creado por MSANCHO" \
			--backtitle $backtitle \
			--nocancel \
			--menu "\nOpciones disponibles:" 20 80 11 \
			"1 - Obtención o actualización de todos los archivos necesarios" "" \
			"2 - Compilar el emulador" "" \
			"3 - DBC's, maps y vmaps - Descarga y colocación en directorio" "" \
			"4 - Instalar y actualizar las Bases de Datos" "" \
			"5 - Configuraciones varias" "" \
			"0 - Volver" "" 2> ~/var22
	  
			opcion22=$(cat ~/var22)
			rm ~/var*

			while [ "$opcion22" != "0 - Volver" ]; do


####################################################################
# Menú - Obtención o actualización de todos los archivos necesarios
####################################################################
			if [ "$opcion22" = "1 - Obtención o actualización de todos los archivos necesarios" ]; then
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nManejo de Repositorios y archivos" 20 60 8 \
				"1 - Descargar repositorios" "" \
				"2 - Actualizar repositorios" "" \
				"0 - Volver" "" 2> ~/var221
			  
				opcion221=$(cat ~/var221)
				rm ~/var*
	
				while [ "$opcion221" != "0 - Volver" ]; do


####################################################################
# Descargar repositorios
####################################################################
				if [ "$opcion221" = "1 - Descargar repositorios" ]; then
					clear
					if [ ! -x $HOME/Repos  ];then
						dialog --title "INFORMACIÓN" \
						--backtitle $backtitle \
						--pause "\nSe va a crear la carpeta de repositorios dentro de nuestro home" 10 50 5
						clear && cd $HOME/ && mkdir Repos
					fi
					if [ ! -x $repoLoc_ac335  ];then
						dialog --title "INFORMACIÓN" \
						--backtitle $backtitle \
						--pause "\nVamos a obtener los repositorios de AzerothCore" 10 50 5
						clear && cd $repos && git clone $repo_ac335 AC335
					else
						dialog --title "INFORMACIÓN" \
						--backtitle $backtitle \
						--msgbox "\nNo es necesario descargar el repositorio. Ya se encuentra en tu equipo. Puedes utlilizar la opción de actualizar repositorios." 14 50
					fi
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nRepositorios están descargados." 8 50
					clear


####################################################################
# Actualizar repositorios 
####################################################################
				elif [ "$opcion221" = "2 - Actualizar repositorios" ]; then
					clear && cd $repoLoc_ac335 && git pull origin master
					read -n 1 -s -r -p "Pulsa una tecla para continuar..." 
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--pause "\nRepositorios del core actualizados." 10 50 5
					clear
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nYa puedes recompilar el emulador de nuevo." 8 50
					clear
				fi


########  CONCLUSIÓN MENÚ Obtención o actualización de todos los archivos necesarios  ########  
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nManejo de Repositorios y archivos" 20 60 8 \
				"1 - Descargar repositorios" "" \
				"2 - Actualizar repositorios" "" \
				"0 - Volver" "" 2> ~/var221
		
				opcion221=$(cat ~/var221)
				rm ~/var*
				done


####################################################################
# Compilar el emulador
####################################################################
			elif [ "$opcion22" = "2 - Compilar el emulador" ]; then
				if [ ! -x $repoLoc_ac335/build  ];then
					cd $repoLoc_ac335 && mkdir build
				fi
				if [ ! -x $HOME/Servers  ];then
					cd $HOME && mkdir Servers
				fi
				cd $repoLoc_ac335/build  && clear
				cmake ../ -DCMAKE_INSTALL_PREFIX=$server_ac335 -DTOOLS=0 -DSCRIPTS=1
				make -j $(nproc) install
				read -n 1 -s -r -p "Pulsa una tecla para continuar..." 
				dialog --title "INFORMACIÓN" \
				--backtitle $backtitle \
				--msgbox "\nHas terminado de compilar tu emulador. Si todo ha salido correctamete lo encontrarás en tu home, dentro de la carpeta Servers/server_ac335" 9 50
				clear


####################################################################
# DBC's, maps y vmaps - Descarga y colocación en directorio
####################################################################
			elif [ "$opcion22" = "3 - DBC's, maps y vmaps - Descarga y colocación en directorio" ]; then
				if [ ! -x $server_ac335/data  ];then
					clear && cd $server_ac335
					wget --no-check-certificate --content-disposition $link_data_ac/download -O data_ac335.zip
					unzip data_ac335.zip && rm data_ac335.zip
					read -n 1 -s -r -p "Pulsa una tecla para continuar..." 
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
# Instalar y actualizar las Bases de Datos
####################################################################

			elif [ "$opcion22" = "4 - Instalar y actualizar las Bases de Datos" ]; then
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nInstalar las Bases de Datos" 20 80 8 \
				"1 - Crear las Bases de datos" "" \
				"2 - Poblar las Bases de datos" "" \
				"3 - Actualizar las Bases de datos" "" \
				"0 - Volver" "" 2> ~/var224

				opcion224=$(cat ~/var224)
				rm ~/var224
	
				while [ "$opcion224" != "0 - Volver" ]; do


####################################################################
# Crear las Bases de datos
####################################################################
				if [ "$opcion224" = "1 - Crear las Bases de datos" ]; then
					dialog --title "ATENCIÓN!" \
					--backtitle $backtitle \
					--defaultno \
					--yesno "\nVas a eliminar cualquier base de datos que tenga los nombres ${world}, ${auth} y ${char} creándolas de nuevo con sus estructuras predeterminadas. ¿Estás seguro?" 10 50 
					if [ $? = 0 ]; then
							mysql -u${user} -p${pass} --port=${port} <<_EOF_
							CREATE DATABASE IF NOT EXISTS ${world} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
							CREATE DATABASE IF NOT EXISTS ${char} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
							CREATE DATABASE IF NOT EXISTS ${auth} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
							FLUSH PRIVILEGES;
_EOF_
						dialog --title "INFORMACIÓN" \
						--backtitle $backtitle \
						--msgbox "\nFinalizada la creación de las bases de datos ${world}, ${auth} y ${char}." 10 50
						clear
					fi


####################################################################
# Poblar las Bases de datos
####################################################################
				elif [ "$opcion224" = "2 - Poblar las Bases de datos" ]; then
					dialog --title "ATENCIÓN!" \
					--backtitle $backtitle \
					--msgbox "\nVamos a insertar todos los datos en las DB de nuestro emulador. Este proceso puede demorar un poco" 10 50
					clear
					echo "Vamos a importar los archivos para la DB $auth"
					sleep 3
					max=`ls -1 "${sql_ac_base}/db_auth"/*.sql | wc -l`
					i=0
					for table in "${sql_ac_base}/db_auth"/*.sql; 
					do
						i=$((${i}+1))
						echo " [${i}/${max}] importando: ${table##*/}"
						mysql -u${user} -p${pass} --port=${port} ${auth} < "${table}"
					done
					echo " Se han instalado todas las tablas a $auth"
					sleep 5

					echo "Vamos a importar los archivos para la DB $char"
					sleep 3
					max=`ls -1 "${sql_ac_base}/db_characters"/*.sql | wc -l`
					i=0
					for table in "${sql_ac_base}/db_characters"/*.sql; 
					do
						i=$((${i}+1))
						echo " [${i}/${max}] importando: ${table##*/}"
						mysql -u${user} -p${pass} --port=${port} ${char} < "${table}"
					done
					echo " Se han instalado todas las tablas a $char"
					sleep 5

					echo "Vamos a importar los archivos para la DB $world"
					sleep 3
					max=`ls -1 "${sql_ac_base}/db_world"/*.sql | wc -l`
					i=0
					for table in "${sql_ac_base}/db_world"/*.sql; 
					do
						i=$((${i}+1))
						echo " [${i}/${max}] importando: ${table##*/}"
						mysql -u${user} -p${pass} --port=${port} ${world} < "${table}"
					done
					echo " Se han instalado todas las tablas a $world"
					read -n 1 -s -r -p "Pulsa una tecla para continuar..." 


####################################################################
# Actualizar las Bases de datos
####################################################################
				elif [ "$opcion224" = "3 - Actualizar las Bases de datos" ]; then
					dialog --title "ATENCIÓN!" \
					--backtitle $backtitle \
					--msgbox "\nVamos a insertar las actualizaciones de las DB de nuestro emulador. Este proceso puede demorar un poco" 10 50
					clear
					echo "Vamos a importar los archivos para la DB $auth"
					sleep 3
					max=`ls -1 "${sql_ac_updates}/db_auth"/*.sql | wc -l`
					i=0
					for table in "${sql_ac_updates}/db_auth"/*.sql; 
					do
						i=$((${i}+1))
						echo " [${i}/${max}] importando: ${table##*/}"
						mysql -u${user} -p${pass} --port=${port} ${auth} < "${table}"
					done
					echo " Se han instalado todas las tablas a $auth"
					sleep 5

					echo "Vamos a importar los archivos para la DB $char"
					sleep 3
					max=`ls -1 "${sql_ac_updates}/db_characters"/*.sql | wc -l`
					i=0
					for table in "${sql_ac_updates}/db_characters"/*.sql; 
					do
						i=$((${i}+1))
						echo " [${i}/${max}] importando: ${table##*/}"
						mysql -u${user} -p${pass} --port=${port} ${char} < "${table}"
					done
					echo " Se han instalado todas las tablas a $char"
					sleep 5

					echo "Vamos a importar los archivos para la DB $world"
					sleep 3
					max=`ls -1 "${sql_ac_updates}/db_world"/*.sql | wc -l`
					i=0
					for table in "${sql_ac_updates}/db_world"/*.sql; 
					do
						i=$((${i}+1))
						echo " [${i}/${max}] importando: ${table##*/}"
						mysql -u${user} -p${pass} --port=${port} ${world} < "${table}"
					done
					echo " Se han instalado todas las tablas a $world"
					read -n 1 -s -r -p "Pulsa una tecla para continuar..." 

				fi


########  CONCLUSIÓN MENÚ Instalar y actualizar las Bases de Datos  ######## 
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nInstalar las Bases de Datos" 20 80 8 \
				"1 - Crear las Bases de datos" "" \
				"2 - Poblar las Bases de datos" "" \
				"3 - Actualizar las Bases de datos" "" \
				"0 - Volver" "" 2> ~/var224
		  
				opcion224=$(cat ~/var224)
				rm ~/var224
				done


####################################################################
# Configuraciones varias
####################################################################
			elif [ "$opcion22" = "5 - Configuraciones varias" ]; then
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nConfiguraciones varias" 20 80 8 \
				"1 - Configurar authserver.conf" "" \
				"2 - Configurar worldserver.conf" "" \
				"3 - Configurar tabla realmlist de la base de datos auth" "" \
				"0 - Volver" "" 2> var225
		  
				opcion225=$(cat var225)
				rm var225

				while [ "$opcion225" != "0 - Volver" ]; do


####################################################################
# Configurar Authserver.conf
####################################################################
				if [ "$opcion225" = "1 - Configurar authserver.conf" ]; then
					if [ ! -x $server_ac335/etc/authserver.temp  ];then
						rm -f $server_ac335/etc/authserver.temp
					fi
					cp $server_ac335/etc/authserver.conf.dist $server_ac335/etc/authserver.temp

					sed -e "s/LoginDatabaseInfo = \"127\.0\.0\.1;3306;acore;acore;acore_auth\"/LoginDatabaseInfo = \"127\.0\.0\.1;port;sqluser;sqlpass;dbauth\"/g" -i $server_ac335/etc/authserver.temp

					conf=$(dialog --title "CONFIGURACIÓN DEL authserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nDirectorio del archivo logs: \nValor por defecto logs" 10 51 logs 2>&1 >/dev/tty)
					sed -e "s/LogsDir = \"\"/LogsDir = \"\.\.\/$conf\"/g" -i $server_ac335/etc/authserver.temp
					if [ ! -x $server_ac335/$conf  ];then
						mkdir $server_ac335/$conf
					fi

					sed -e "s/port/$port/g" -i $server_ac335/etc/authserver.temp

					sed -e "s/sqluser/$user/g" -i $server_ac335/etc/authserver.temp

					sed -e "s/sqlpass/$pass/g" -i $server_ac335/etc/authserver.temp

					sed -e "s/dbauth/$auth/g" -i $server_ac335/etc/authserver.temp

					# PidFile = "auth.pid" NO TOCAR!!! IMPRESCINDIBLE.
					sed -e "s/PidFile = \"\"/PidFile = \"authserver.pid\"/g" -i $server_ac335/etc/authserver.temp

					cp $server_ac335/etc/authserver.temp $server_ac335/etc/authserver.conf

					rm -f $server_ac335/etc/authserver.temp
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nEl resto de valores se han configurado automáticamente con los datos que has introducido al arrancar el script. Ya puedes arrancar el servidor de logueo." 10 50
					clear


####################################################################
# Configurar Worldserver.conf
####################################################################
				elif [ "$opcion225" = "2 - Configurar worldserver.conf" ]; then
					if [ ! -x $server_ac335/etc/world.conf  ];then
						rm -f $server_ac335/etc/world.conf
					fi
					cp $server_ac335/etc/worldserver.conf.dist $server_ac335/etc/world.conf
					sed -e "s/LoginDatabaseInfo     = \"127\.0\.0\.1;3306;acore;acore;acore_auth\"/LoginDatabaseInfo     = \"127\.0\.0\.1;port;sqluser;sqlpass;dbauth\"/g" -i $server_ac335/etc/world.conf
					sed -e "s/WorldDatabaseInfo     = \"127\.0\.0\.1;3306;acore;acore;acore_world\"/WorldDatabaseInfo     = \"127\.0\.0\.1;port;sqluser;sqlpass;dbworld\"/g" -i $server_ac335/etc/world.conf
					sed -e "s/CharacterDatabaseInfo = \"127\.0\.0\.1;3306;acore;acore;acore_characters\"/CharacterDatabaseInfo = \"127\.0\.0\.1;port;sqluser;sqlpass;dbchar\"/g" -i $server_ac335/etc/world.conf

					conf5=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 1/29\n\nDirectorio del archivo data: \nValor por defecto data" 12 51 data 2>&1 >/dev/tty)
					sed -e "s/DataDir = \"\.\"/DataDir = \"\.\.\/$conf5\"/g" -i $server_ac335/etc/world.conf

					conf6=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 2/29\n\nDirectorio del archivo logs: \nValor por defecto logs" 12 51 logs 2>&1 >/dev/tty)
					sed -e "s/LogsDir = \"\"/LogsDir = \"\.\.\/$conf6\"/g" -i $server_ac335/etc/world.conf
					if [ ! -x $server_ac335/$conf6  ];then
						mkdir $server_ac335/$conf6
					fi

					sed -e "s/port/$port/g" -i $server_ac335/etc/world.conf

					sed -e "s/sqluser/$user/g" -i $server_ac335/etc/world.conf

					sed -e "s/sqlpass/$pass/g" -i $server_ac335/etc/world.conf

					sed -e "s/dbauth/$auth/g" -i $server_ac335/etc/world.conf

					sed -e "s/dbworld/$world/g" -i $server_ac335/etc/world.conf

					sed -e "s/dbchar/$char/g" -i $server_ac335/etc/world.conf

					conf7=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 3/29\n\nPuerto de conexión al worldserver: \nValor por defecto 8085" 12 51 8085 2>&1 >/dev/tty)
					sed -e "s/WorldServerPort = 8085/WorldServerPort = $conf7/g" -i $server_ac335/etc/world.conf

					conf8=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 4/29\n\nLímite de jugadores conectados simultaneamente.\nSi escribimos 0 no hay límite de conectados.\nValor por defecto 100" 12 51 100 2>&1 >/dev/tty)
					sed -e "s/PlayerLimit = 0/PlayerLimit = $conf8/g" -i $server_ac335/etc/world.conf

					sed -e "s/MaxCoreStuckTime = 0/MaxCoreStuckTime = 15/g" -i $server_ac335/etc/world.conf

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--nocancel \
					--menu "\nOpción 5/29\n\nTipo de Reino - Quieres un reino PVP o Normal?\nEn los reinos normales se puede desconetar que los de la facción contraria te puedan atacer. En los PVP te pueden atacar menos en los santuarios.\n\n\n\n" 20 80 4 \
					"1 - Reino PVP" "" \
					"2 - Reino Normal" "" 2> conf9
					conf9=$(cat conf9)
					if [ "$conf9" = "1 - Reino PVP" ]; then
						sed -e "s/GameType = 0/GameType = 1/g" -i $server_ac335/etc/world.conf
					else
						sed -e "s/GameType = 0/GameType = 0/g" -i $server_ac335/etc/world.conf
					fi
					rm conf9

					#RESERVADO

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 6/29\n\n¿Quieres que se anuncien por taberna los eventos automáticos?" 12 51
					if [ $? = 0 ]; then
						sed -e "s/Event.Announce = 0/Event.Announce = 1/g" -i $server_ac335/etc/world.conf
					fi

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 7/29\n\n¿Quieres que los Alianzas y los Hordas se puedan comunicar por el canal \"decir\"?" 12 51
					if [ $? = 0 ]; then
						sed -e "s/AllowTwoSide.Interaction.Chat = 0/AllowTwoSide.Interaction.Chat = 1/g" -i $server_ac335/etc/world.conf
					fi

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 8/29\n\n¿Quieres que los Alianzas y los Hordas se puedan comunicar por emociones?" 12 51
					if [ $? = 0 ]; then
						sed -e "s/AllowTwoSide.Interaction.Emote = 0/AllowTwoSide.Interaction.Emote = 1/g" -i $server_ac335/etc/world.conf
					fi

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 9/29\n\n¿Quieres que los Alianzas y los Hordas se puedan comunicar por los canales de chat como taberna?" 12 51
					if [ $? = 0 ]; then
						sed -e "s/AllowTwoSide.Interaction.Channel = 0/AllowTwoSide.Interaction.Channel = 1/g" -i $server_ac335/etc/world.conf
					fi

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 10/29\n\n¿Quieres que se puedan crear grupos mixtos entre Hordas y Alianzas?\nEsto es útil para cuando hay poca población en el servidor poder hacer mazmorras o raids conjuntamente." 12 51
					if [ $? = 0 ]; then
						sed -e "s/AllowTwoSide.Interaction.Group = 0/AllowTwoSide.Interaction.Group = 1/g" -i $server_ac335/etc/world.conf
					fi

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 11/29\n\n¿Quieres que se pueda interactuar en las subastas entre Hordas y Alianzas?\nEsto es útil para cuando hay poca población en el servidor." 12 51
					if [ $? = 0 ]; then
						sed -e "s/AllowTwoSide.Interaction.Auction = 0/AllowTwoSide.Interaction.Auction = 1/g" -i $server_ac335/etc/world.conf
					fi

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 12/29\n\n¿Quieres que se pueda comerciar con la facción contraria?." 12 51
					if [ $? = 0 ]; then
						sed -e "s/AllowTwoSide.Trade = 0/AllowTwoSide.Trade = 1/g" -i $server_ac335/etc/world.conf
					fi

					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nOpción 13/29\n\nRATES DEL SERVIDOR:\n\nLos rates son lo que determinan lo rápido que se avanza en el juego.\nLos servidores de Blizzard tienen un rate de x1 por lo que si nosotros ponemos rates x3 se multiplican los valores al triple.\nEjemplo: Ponemos rates de experiencia al matar bichos x3. Si al nivel 10 para subir al 11 debemos matar 30 zebras en el de Blizzard, al nuestro con 10 ya sería suficiente." 22 60
					clear

					conf10=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 14/29\n\nRATES DEL SERVIDOR:\nRates de objetos mediocres(grises)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Poor             = 1/Rate.Drop.Item.Poor             = $conf10/g" -i $server_ac335/etc/world.conf

					conf11=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 15/29\n\nRATES DEL SERVIDOR:\nRates de objetos normales(blancos)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Normal           = 1/Rate.Drop.Item.Normal           = $conf11/g" -i $server_ac335/etc/world.conf

					conf12=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 16/29\n\nRATES DEL SERVIDOR:\nRates de objetos poco frecuentes(verdes)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Uncommon         = 1/Rate.Drop.Item.Uncommon         = $conf12/g" -i $server_ac335/etc/world.conf

					conf13=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 17/29\n\nRATES DEL SERVIDOR:\nRates de objetos raros(azules)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Rare             = 1/Rate.Drop.Item.Rare             = $conf13/g" -i $server_ac335/etc/world.conf

					conf14=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 18/29\n\nRATES DEL SERVIDOR:\nRates de objetos épicos(morados)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Epic             = 1/Rate.Drop.Item.Epic             = $conf14/g" -i $server_ac335/etc/world.conf

					conf15=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 19/29\n\nRATES DEL SERVIDOR:\nRates de objetos legendarios(anaranjados)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Legendary        = 1/Rate.Drop.Item.Legendary        = $conf15/g" -i $server_ac335/etc/world.conf

					conf16=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 20/29\n\nRATES DEL SERVIDOR:\nRates de objetos artefactos" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Artifact         = 1/Rate.Drop.Item.Artifact         = $conf16/g" -i $server_ac335/etc/world.conf

					conf17=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 21/29\n\nRATES DEL SERVIDOR:\nRates de objetos de misión" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.ReferencedAmount = 1/Rate.Drop.Item.ReferencedAmount = $conf17/g" -i $server_ac335/etc/world.conf

					conf18=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 22/29\n\nRATES DEL SERVIDOR:\nRates de dinero" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Money                 = 1/Rate.Drop.Money                 = $conf18/g" -i $server_ac335/etc/world.conf

					conf19=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 23/29\n\nRATES DEL SERVIDOR:\nRates experiencia por muertes" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.XP.Kill    = 1/Rate.XP.Kill    = $conf19/g" -i $server_ac335/etc/world.conf

					conf20=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 24/29\n\nRATES DEL SERVIDOR:\nRates experiencia en misiones" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.XP.Quest   = 1/Rate.XP.Quest   = $conf20/g" -i $server_ac335/etc/world.conf

					conf21=$(dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 25/29\n\nRATES DEL SERVIDOR:\nRates experiencia por exploración" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.XP.Explore = 1/Rate.XP.Explore = $conf21/g" -i $server_ac335/etc/world.conf

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 26/29\n\n¿Quieres que se anuncie por canal global cuando se anote alguien a BG?\nEsto es útil para cuando hay poca población en el servidor." 12 51
					if [ $? = 0 ]; then
						sed -e "s/Battleground.QueueAnnouncer.Enable = 0/Battleground.QueueAnnouncer.Enable = 1/g" -i $server_ac335/etc/world.conf
					fi

					# RESERVADO

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 27/29\n\n¿Quieres que se adjudiquen los puntos de arenas automáticamente cada semana? Es recomendable que sí." 12 51
					if [ $? = 0 ]; then
						sed -e "s/Arena.AutoDistributePoints = 0/Arena.AutoDistributePoints = 1/g" -i $server_ac335/etc/world.conf
					fi

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 28/29\n\n¿Quieres que se anuncie por canal global cuando se anote un grupo a arenas?\nEsto es útil para cuando hay poca población en el servidor." 12 51
					if [ $? = 0 ]; then
						sed -e "s/Arena.QueueAnnouncer.Enable = 0/Arena.QueueAnnouncer.Enable = 1/g" -i $server_ac335/etc/world.conf
					fi

					dialog --title "CONFIGURACIÓN DEL worldserver.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 29/29\n\n¿Deseas activar el acceso a la máquina por telnet?\nEsto es necesario si quieres tener una tienda de artículos en la web o gestionar el servidor remotamente." 12 51
					if [ $? = 0 ]; then
						sed -e "s/Ra.Enable = 0/Ra.Enable = 1/g" -i $server_ac335/etc/world.conf
					fi

					### Configuraciones que cambiamos automáticamente:

					sed -e "s/Motd = \"Welcome to an AzerothCore server.\"/Motd = \"Bienvenido a nuestro servidor. Esperamos que sea de tu agrado.\"/g" -i $server_ac335/etc/world.conf

					#PidFile = "world.pid"  IMPRESCINDIBLE!!! NO TOCAR.  
					sed -e "s/PidFile = \"\"/PidFile = \"world.pid\"/g" -i $server_ac335/etc/world.conf

					cp $server_ac335/etc/world.conf $server_ac335/etc/worldserver.conf
					rm -f $server_ac335/etc/world.conf
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nHas configurado el archivo worldserver.conf.\n\nSi los valores que has introducido son correctos ya puedes arrancar el servidor del juego." 10 50
					clear


####################################################################
# Configurar tabla realmlist de la base de datos auth
####################################################################
				elif [ "$opcion225" = "3 - Configurar tabla realmlist de la base de datos auth" ]; then
					rm -f $server_tc335/etc/confrealm.sql
					echo "REPLACE INTO \`realmlist\` (\`id\`,\`name\`,\`address\`,\`localAddress\`,\`port\`,\`icon\`,\`flag\`,\`timezone\`,\`allowedSecurityLevel\`,\`population\`,\`gamebuild\`) VALUES
(1,'NombreReino','addressReino','127.0.0.1',portReino,1,2,1,0,0,12340);" >> $server_tc335/etc/confrealm.sql
					
					conf1=$(dialog --title "CONFIGURACIÓN TABLA realmlist de la DB auth" \
					--backtitle $backtitle \
					--inputbox "\nNombre que le quieres dar a tu reino:" 10 51 Trinity 2>&1 >/dev/tty)
					sed -e "s/NombreReino/$conf1/g" -i $server_tc335/etc/confrealm.sql

					conf2=$(dialog --title "CONFIGURACIÓN TABLA realmlist de la DB auth" \
					--backtitle $backtitle \
					--inputbox "\nIp externa de conexión a tu servidor. Si lo ejecutas en local deja el valor predeterminado:" 10 51 127.0.0.1 2>&1 >/dev/tty)
					sed -e "s/addressReino/$conf2/g" -i $server_tc335/etc/confrealm.sql

					conf3=$(dialog --title "CONFIGURACIÓN TABLA realmlist de la DB auth" \
					--backtitle $backtitle \
					--inputbox "\nDirección LAN de tu servidor. IMPRESCINDIBLE:" 10 51 192.168.1.150 2>&1 >/dev/tty)
					sed -e "s/127.0.0.1/$conf3/g" -i $server_tc335/etc/confrealm.sql

					conf4=$(dialog --title "CONFIGURACIÓN TABLA realmlist de la DB auth" \
					--backtitle $backtitle \
					--inputbox "\nPuerto de conexión:" 10 51 8085 2>&1 >/dev/tty)
					sed -e "s/portReino/$conf4/g" -i $server_tc335/etc/confrealm.sql

					mysql -u${user} -p${pass} --port=${port} $auth < $server_tc335/etc/confrealm.sql
					rm -f $server_tc335/etc/confrealm.sql
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nYa tienes la Tabla realmlist configurada" 10 50
					clear
				fi


########  CONCLUSIÓN MENÚ Configuraciones varias  ########
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nConfiguraciones varias" 20 80 8 \
				"1 - Configurar authserver.conf" "" \
				"2 - Configurar worldserver.conf" "" \
				"3 - Configurar tabla realmlist de la base de datos auth" "" \
				"0 - Volver" "" 2> var225
		  
				opcion225=$(cat var225)
				rm var225
				done
			fi


########  CONCLUSIÓN MENÚ AzerothCore WotLK 3.3.5  ######## 
			dialog --title "Menú de opciones --- Creado por MSANCHO" \
			--backtitle $backtitle \
			--nocancel \
			--menu "\nOpciones disponibles:" 20 80 11 \
			"1 - Obtención o actualización de todos los archivos necesarios" "" \
			"2 - Compilar el emulador" "" \
			"3 - DBC's, maps y vmaps - Descarga y colocación en directorio" "" \
			"4 - Instalar y actualizar las Bases de Datos" "" \
			"5 - Configuraciones varias" "" \
			"0 - Volver" "" 2> ~/var22
	  
			opcion22=$(cat ~/var22)
			rm ~/var*
			done
		fi


#####################################################################################################
# Menú - Vanilla MaNGOS 1.2/1.12
#####################################################################################################
		if [ "$opcion2" = "3 - Vanilla MaNGOS 1.2/1.12" ]; then
			dialog --title "Menú de opciones --- Creado por MSANCHO" \
			--backtitle $backtitle \
			--nocancel \
			--menu "\nOpciones disponibles:" 20 80 11 \
			"1 - Obtención o actualización de todos los archivos necesarios" "" \
			"2 - Compilar el emulador" "" \
			"3 - DBC's, maps y vmaps - Descarga y colocación en directorio" "" \
			"4 - Instalar y actualizar las Bases de Datos" "" \
			"5 - Configuraciones varias" "" \
			"0 - Volver" "" 2> ~/var23
	  
			opcion23=$(cat ~/var23)
			rm ~/var*

			while [ "$opcion23" != "0 - Volver" ]; do


####################################################################
# Menú - Obtención o actualización de todos los archivos necesarios
####################################################################
			if [ "$opcion23" = "1 - Obtención o actualización de todos los archivos necesarios" ]; then
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nManejo de Repositorios y archivos" 20 60 8 \
				"1 - Descargar repositorios" "" \
				"2 - Actualizar repositorios" "" \
				"0 - Volver" "" 2> ~/var231
			  
				opcion231=$(cat ~/var231)
				rm ~/var*
	
				while [ "$opcion231" != "0 - Volver" ]; do


####################################################################
# Descargar repositorios
####################################################################
				if [ "$opcion231" = "1 - Descargar repositorios" ]; then
					clear
					if [ ! -x $HOME/Repos  ];then
						dialog --title "INFORMACIÓN" \
						--backtitle $backtitle \
						--pause "\nSe va a crear la carpeta de repositorios dentro de nuestro home" 10 50 5
						clear && cd $HOME/ && mkdir Repos
					fi
					if [ ! -x $repoLoc_vmangos  ];then
						dialog --title "INFORMACIÓN" \
						--backtitle $backtitle \
						--pause "\nVamos a obtener los repositorios de vmangos" 10 50 5
						clear && cd $repos && git clone $repo_vmangos vmangos
					else
						dialog --title "INFORMACIÓN" \
						--backtitle $backtitle \
						--msgbox "\nNo es necesario descargar el repositorio de vmangos. Ya se encuentra en tu equipo. Puedes utlilizar la opción de actualizar repositorios." 14 50
					fi
					if [ ! -x $repoLoc_db_vmangos  ];then
						dialog --title "INFORMACIÓN" \
						--backtitle $backtitle \
						--pause "\nVamos a obtener los repositorios de la base de datos vmangos(brotalnia)" 10 50 5
						clear && mkdir $repoLoc_db_vmangos
						cd $repoLoc_db_vmangos && wget $db_vmangos
						7z e $arch_comp_db_vmangos -aos
					else
						dialog --title "INFORMACIÓN" \
						--backtitle $backtitle \
						--msgbox "\nNo es necesario descargar el repositorio brotalnia. Ya se encuentra en tu equipo. Puedes utlilizar la opción de actualizar repositorios." 14 50
					fi
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nRepositorios están descargados." 8 50
					clear


####################################################################
# Actualizar repositorios 
####################################################################
				elif [ "$opcion231" = "2 - Actualizar repositorios" ]; then
					clear && cd $repoLoc_vmangos && git pull origin development
					read -n 1 -s -r -p "Pulsa una tecla para continuar..." 
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--pause "\nRepositorios del core actualizados. Ya puedes recompilar el emulador de nuevo" 10 50
				fi


########  CONCLUSIÓN MENÚ Obtención o actualización de todos los archivos necesarios  ########  
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nManejo de Repositorios y archivos" 20 60 8 \
				"1 - Descargar repositorios" "" \
				"2 - Actualizar repositorios" "" \
				"0 - Volver" "" 2> ~/var231
		
				opcion231=$(cat ~/var231)
				rm ~/var*
				done


####################################################################
# Compilar el emulador
####################################################################
			elif [ "$opcion23" = "2 - Compilar el emulador" ]; then
				if [ ! -x $repoLoc_vmangos/build  ];then
					cd $repoLoc_vmangos && mkdir build
				fi
				if [ ! -x $HOME/Servers  ];then
					cd $HOME && mkdir Servers
				fi
				cd $repoLoc_vmangos/build  && clear
				cmake ../ -DCMAKE_INSTALL_PREFIX=$server_vmangos -DBUILD_EXTRACTORS=OFF -DPCH=ON -DBUILD_PLAYERBOT=ON
				make -j $(nproc) install
				read -n 1 -s -r -p "Pulsa una tecla para continuar..." 
				dialog --title "INFORMACIÓN" \
				--backtitle $backtitle \
				--msgbox "\nHas terminado de compilar tu emulador. Si todo ha salido correctamete lo encontrarás en tu home, dentro de la carpeta Servers/server_vmangos" 9 50
				clear


####################################################################
# DBC's, maps y vmaps - Descarga y colocación en directorio
####################################################################
			elif [ "$opcion23" = "3 - DBC's, maps y vmaps - Descarga y colocación en directorio" ]; then
				if [ ! -x $server_vmangos/data  ];then
					clear && cd $server_vmangos
					wget --no-check-certificate --content-disposition $link_data_vmangos/download -O data_vmangos.zip
					unzip data_vmangos.zip && rm data_vmangos.zip
					read -n 1 -s -r -p "Pulsa una tecla para continuar..." 
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
# Instalar y actualizar las Bases de Datos
####################################################################

			elif [ "$opcion23" = "4 - Instalar y actualizar las Bases de Datos" ]; then
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nInstalar las Bases de Datos" 20 80 8 \
				"1 - Crear las Bases de datos" "" \
				"2 - Poblar las Bases de datos" "" \
				"3 - Actualizar las Bases de datos" "" \
				"0 - Volver" "" 2> ~/var234

				opcion234=$(cat ~/var234)
				rm ~/var234
	
				while [ "$opcion234" != "0 - Volver" ]; do


####################################################################
# Crear las Bases de datos de vmangos
####################################################################
				if [ "$opcion234" = "1 - Crear las Bases de datos" ]; then
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nNormalmente las bases de datos en emuladores basados en MaNGOS no tienen los mismos nombres que en Trinity y derivados. Por este motivo, especificaremos los nombres de nuevo para este emulador" 14 50
					clear
					realmd=$(dialog --title "DATOS DE CONEXIÓN" \
					--backtitle $backtitle \
					--nocancel \
					--inputbox "\nBase de datos auth: \nValor por defecto classic_realmd" 10 51 classic_realmd 2>&1 >/dev/tty)

					vchar=$(dialog --title "DATOS DE CONEXIÓN" \
					--backtitle $backtitle \
					--nocancel \
					--inputbox "\nBase de datos characters: \nValor por defecto classic_characters" 10 51 classic_characters 2>&1 >/dev/tty)

					mangos=$(dialog --title "DATOS DE CONEXIÓN" \
					--backtitle $backtitle \
					--nocancel \
					--inputbox "\nBase de datos world: \nValor por defecto classic_mangos" 10 51 classic_mangos 2>&1 >/dev/tty)

					logs=$(dialog --title "DATOS DE CONEXIÓN" \
					--backtitle $backtitle \
					--nocancel \
					--inputbox "\nBase de datos logs: \nValor por defecto classic_logs" 10 51 classic_logs 2>&1 >/dev/tty)
					
					dialog --title "ATENCIÓN!" \
					--backtitle $backtitle \
					--defaultno \
					--yesno "\nVas a eliminar cualquier base de datos que tenga los nombres ${mangos}, ${realmd}, ${vchar} y ${logs} creándolas de nuevo con sus estructuras predeterminadas. ¿Estás seguro?" 10 50 
					if [ $? = 0 ]; then
							mysql -u${user} -p${pass} --port=${port} <<_EOF_
							CREATE DATABASE IF NOT EXISTS ${mangos} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
							CREATE DATABASE IF NOT EXISTS ${vchar} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
							CREATE DATABASE IF NOT EXISTS ${realmd} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
							CREATE DATABASE IF NOT EXISTS ${logs} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
							FLUSH PRIVILEGES;
_EOF_
						dialog --title "INFORMACIÓN" \
						--backtitle $backtitle \
						--msgbox "\nFinalizada la creación de las bases de datos ${mangos}, ${realmd}, ${vchar} y ${logs}." 10 50
						clear
					fi


####################################################################
# Poblar las Bases de datos
####################################################################
				elif [ "$opcion234" = "2 - Poblar las Bases de datos" ]; then
					dialog --title "ATENCIÓN!" \
					--backtitle $backtitle \
					--msgbox "\nVamos a insertar todos los datos en las DB de nuestro emulador. Este proceso puede demorar un poco." 14 50
					clear
					mysql -u${user} -p${pass} --port=${port} $mangos < $repoLoc_db_vmangos/$arch_sql_db_vmangos
					mysql -u${user} -p${pass} --port=${port} $realmd < $repoLoc_vmangos/sql/logon.sql
					mysql -u${user} -p${pass} --port=${port} $vchar < $repoLoc_vmangos/sql/characters.sql
					mysql -u${user} -p${pass} --port=${port} $logs < $repoLoc_vmangos/sql/logs.sql

			
####################################################################
# Actualizar las Bases de datos
####################################################################
				elif [ "$opcion234" = "3 - Actualizar las Bases de datos" ]; then
					dialog --title "ATENCIÓN!" \
					--backtitle $backtitle \
					--msgbox "\nVamos a insertar las actualizaciones de las DB de nuestro emulador. Este proceso puede demorar un poco" 10 50
					clear
					chmod +x $repoLoc_vmangos/sql/migrations/merge.sh
					cd $repoLoc_vmangos/sql/migrations && sh merge.sh
					if [ -z "$realmd" ]; then
						realmd=$(dialog --title "DATOS DE CONEXIÓN" \
						--backtitle $backtitle \
						--nocancel \
						--inputbox "\nBase de datos auth: \nValor por defecto classic_realmd" 10 51 classic_realmd 2>&1 >/dev/tty)
					fi

					if [ -z "$mangos" ]; then
						mangos=$(dialog --title "DATOS DE CONEXIÓN" \
						--backtitle $backtitle \
						--nocancel \
						--inputbox "\nBase de datos auth: \nValor por defecto classic_mangos" 10 51 classic_mangos 2>&1 >/dev/tty)
					fi

					if [ -z "$vchar" ]; then
						vchar=$(dialog --title "DATOS DE CONEXIÓN" \
						--backtitle $backtitle \
						--nocancel \
						--inputbox "\nBase de datos auth: \nValor por defecto classic_characters" 10 51 classic_characters 2>&1 >/dev/tty)
					fi

					if [ -z "$logs" ]; then
						logs=$(dialog --title "DATOS DE CONEXIÓN" \
						--backtitle $backtitle \
						--nocancel \
						--inputbox "\nBase de datos auth: \nValor por defecto classic_logs" 10 51 classic_logs 2>&1 >/dev/tty)
					fi
					clear
					echo "Actualizando datos..."
					if [ $repoLoc_vmangos/sql/migrations/world_db_updates.sql  ];then
						mysql -u${user} -p${pass} --port=${port} $mangos < $repoLoc_vmangos/sql/migrations/world_db_updates.sql
					fi
					if [ $repoLoc_vmangos/sql/migrations/logon_db_updates.sql  ];then
						mysql -u${user} -p${pass} --port=${port} $realmd < $repoLoc_vmangos/sql/migrations/logon_db_updates.sql
					fi
					if [ $repoLoc_vmangos/sql/migrations/characters_db_updates.sql  ];then
						mysql -u${user} -p${pass} --port=${port} $vchar < $repoLoc_vmangos/sql/migrations/characters_db_updates.sql
					fi
					if [ $repoLoc_vmangos/sql/migrations/logs_db_updates.sql  ];then
						mysql -u${user} -p${pass} --port=${port} $logs < $repoLoc_vmangos/sql/migrations/logs_db_updates.sql
					fi
				fi


########  CONCLUSIÓN MENÚ Instalar y actualizar las Bases de Datos  ######## 
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nInstalar las Bases de Datos" 20 80 8 \
				"1 - Crear las Bases de datos" "" \
				"2 - Poblar las Bases de datos" "" \
				"3 - Actualizar las Bases de datos" "" \
				"0 - Volver" "" 2> ~/var234
		  
				opcion234=$(cat ~/var234)
				rm ~/var234
				done


####################################################################
# Configuraciones varias
####################################################################
			elif [ "$opcion23" = "5 - Configuraciones varias" ]; then
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nConfiguraciones varias" 20 80 8 \
				"1 - Configurar realmd.conf" "" \
				"2 - Configurar mangosd.conf" "" \
				"3 - Configurar tabla realmlist de la base de datos realmd" "" \
				"0 - Volver" "" 2> var235
		  
				opcion235=$(cat var235)
				rm var235

				while [ "$opcion235" != "0 - Volver" ]; do


####################################################################
# Configurar realmd.conf
####################################################################
				if [ "$opcion235" = "1 - Configurar realmd.conf" ]; then
					if [ ! -x $server_vmangos/etc/realmd.temp  ];then
						rm -f $server_vmangos/etc/realmd.temp
					fi
					cp $server_vmangos/etc/realmd.conf.dist $server_vmangos/etc/realmd.temp

					sed -e "s/LoginDatabaseInfo = \"127\.0\.0\.1;3306;mangos;mangos;realmd\"/LoginDatabaseInfo = \"127\.0\.0\.1;port;sqluser;sqlpass;dbauth\"/g" -i $server_vmangos/etc/realmd.temp

					conf=$(dialog --title "CONFIGURACIÓN DEL authserver.conf" \
					--backtitle $backtitle \
					--inputbox "\nDirectorio del archivo logs: \nValor por defecto logs" 10 51 logs 2>&1 >/dev/tty)
					sed -e "s/LogsDir = \"\"/LogsDir = \"\.\.\/$conf\"/g" -i $server_vmangos/etc/realmd.temp
					if [ ! -x $server_vmangos/$conf  ];then
						mkdir $server_vmangos/$conf
					fi

					sed -e "s/port/$port/g" -i $server_vmangos/etc/realmd.temp

					sed -e "s/sqluser/$user/g" -i $server_vmangos/etc/realmd.temp

					sed -e "s/sqlpass/$pass/g" -i $server_vmangos/etc/realmd.temp

					if [ -z "$realmd" ]; then
						realmd=$(dialog --title "DATOS DE CONEXIÓN" \
						--backtitle $backtitle \
						--nocancel \
						--inputbox "\nBase de datos auth: \nValor por defecto classic_realmd" 10 51 classic_realmd 2>&1 >/dev/tty)
					fi

					sed -e "s/dbauth/$realmd/g" -i $server_vmangos/etc/realmd.temp

					# PidFile = "auth.pid" NO TOCAR!!! IMPRESCINDIBLE.
					sed -e "s/PidFile = \"\"/PidFile = \"realmd.pid\"/g" -i $server_vmangos/etc/realmd.temp

					cp $server_vmangos/etc/realmd.temp $server_vmangos/etc/realmd.conf

					rm -f $server_vmangos/etc/realmd.temp
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nEl resto de valores se han configurado automáticamente con los datos que has introducido al arrancar el script. Ya puedes arrancar el servidor de logueo." 10 50
					clear


####################################################################
# Configurar mangosd.conf
####################################################################
				elif [ "$opcion235" = "2 - Configurar mangosd.conf" ]; then
					if [ ! -x $server_vmangos/etc/mangosd.conf  ];then
						rm -f $server_vmangos/etc/mangosd.conf
					fi
					cp $server_vmangos/etc/mangosd.conf.dist $server_vmangos/etc/mangosd.conf.temp
					sed -e "s/LoginDatabase.Info              = \"127\.0\.0\.1;3306;mangos;mangos;realmd\"/LoginDatabase.Info              = \"127\.0\.0\.1;port;sqluser;sqlpass;dbauth\"/g" -i $server_vmangos/etc/mangosd.conf.temp
					sed -e "s/WorldDatabase.Info              = \"127\.0\.0\.1;3306;mangos;mangos;mangos\"/WorldDatabase.Info              = \"127\.0\.0\.1;port;sqluser;sqlpass;dbworld\"/g" -i $server_vmangos/etc/mangosd.conf.temp
					sed -e "s/CharacterDatabase.Info          = \"127\.0\.0\.1;3306;mangos;mangos;characters\"/CharacterDatabase.Info          = \"127\.0\.0\.1;port;sqluser;sqlpass;dbchar\"/g" -i $server_vmangos/etc/mangosd.conf.temp
					sed -e "s/LogsDatabase.Info               = \"127\.0\.0\.1;3306;mangos;mangos;logs\"/LogsDatabase.Info               = \"127\.0\.0\.1;port;sqluser;sqlpass;dblogs\"/g" -i $server_vmangos/etc/mangosd.conf.temp

					conf6=$(dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 1/23\n\nDirectorio del archivo data: \nValor por defecto data" 12 51 data 2>&1 >/dev/tty)
					sed -e "s/DataDir = \"\.\"/DataDir = \"\.\.\/$conf6\"/g" -i $server_vmangos/etc/mangosd.conf.temp

					conf7=$(dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 2/23\n\nDirectorio del archivo logs: \nValor por defecto logs" 12 51 logs 2>&1 >/dev/tty)
					sed -e "s/LogsDir = \"\"/LogsDir = \"\.\.\/$conf7\"/g" -i $server_vmangos/etc/mangosd.conf.temp
					if [ ! -x $server_vmangos/$conf7  ];then
						mkdir $server_vmangos/$conf7
					fi

					sed -e "s/port/$port/g" -i $server_vmangos/etc/mangosd.conf.temp

					sed -e "s/sqluser/$user/g" -i $server_vmangos/etc/mangosd.conf.temp

					sed -e "s/sqlpass/$pass/g" -i $server_vmangos/etc/mangosd.conf.temp

					if [ -z "$realmd" ]; then
						realmd=$(dialog --title "DATOS DE CONEXIÓN" \
						--backtitle $backtitle \
						--nocancel \
						--inputbox "\nBase de datos auth: \nValor por defecto classic_realmd" 10 51 classic_realmd 2>&1 >/dev/tty)
					fi

					if [ -z "$mangos" ]; then
						mangos=$(dialog --title "DATOS DE CONEXIÓN" \
						--backtitle $backtitle \
						--nocancel \
						--inputbox "\nBase de datos auth: \nValor por defecto classic_mangos" 10 51 classic_mangos 2>&1 >/dev/tty)
					fi

					if [ -z "$vchar" ]; then
						vchar=$(dialog --title "DATOS DE CONEXIÓN" \
						--backtitle $backtitle \
						--nocancel \
						--inputbox "\nBase de datos auth: \nValor por defecto classic_characters" 10 51 classic_characters 2>&1 >/dev/tty)
					fi

					if [ -z "$logs" ]; then
						logs=$(dialog --title "DATOS DE CONEXIÓN" \
						--backtitle $backtitle \
						--nocancel \
						--inputbox "\nBase de datos auth: \nValor por defecto classic_logs" 10 51 classic_logs 2>&1 >/dev/tty)
					fi

					sed -e "s/dbauth/$realmd/g" -i $server_vmangos/etc/mangosd.conf.temp

					sed -e "s/dbworld/$mangos/g" -i $server_vmangos/etc/mangosd.conf.temp

					sed -e "s/dbchar/$vchar/g" -i $server_vmangos/etc/mangosd.conf.temp

					sed -e "s/dblogs/$logs/g" -i $server_vmangos/etc/mangosd.conf.temp

					conf13=$(dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 3/23\n\nPuerto de conexión al worldserver: \nValor por defecto 8089" 12 51 8089 2>&1 >/dev/tty)
					sed -e "s/WorldServerPort = 8085/WorldServerPort = $conf13/g" -i $server_vmangos/etc/mangosd.conf.temp

					dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--nocancel \
					--menu "\nOpción 4/23\n\nTipo de Reino - Quieres un reino PVP o Normal?\nEn los reinos normales se puede desconetar que los de la facción contraria te puedan atacer. En los PVP te pueden atacar menos en los santuarios.\n\n\n\n" 20 80 4 \
					"1 - Reino PVP" "" \
					"2 - Reino Normal" "" 2> conf16
					conf16=$(cat conf16)
					if [ "$conf16" = "1 - Reino PVP" ]; then
						sed -e "s/GameType = 1/GameType = 1/g" -i $server_vmangos/etc/mangosd.conf.temp
					else
						sed -e "s/GameType = 1/GameType = 0/g" -i $server_vmangos/etc/mangosd.conf.temp
					fi
					rm conf16

					#RESERVADO

					dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 5/23\n\n¿Quieres que se pueda crear hordas y Alis en la misma cuenta?" 12 51
					if [ $? = 0 ]; then
						sed -e "s/AllowTwoSide.Accounts = 0/AllowTwoSide.Accounts = 1/g" -i $server_vmangos/etc/mangosd.conf.temp
					fi

					dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 6/23\n\n¿Quieres que los Alianzas y los Hordas se puedan comunicar por el canal \"decir\"?" 12 51
					if [ $? = 0 ]; then
						sed -e "s/AllowTwoSide.Interaction.Chat = 0/AllowTwoSide.Interaction.Chat = 1/g" -i $server_vmangos/etc/mangosd.conf.temp
					fi

					dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 7/23\n\n¿Quieres que los Alianzas y los Hordas se puedan comunicar por los canales de chat como taberna?" 12 51
					if [ $? = 0 ]; then
						sed -e "s/AllowTwoSide.Interaction.Channel = 0/AllowTwoSide.Interaction.Channel = 1/g" -i $server_vmangos/etc/mangosd.conf.temp
					fi

					dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 8/23\n\n¿Quieres que se puedan crear grupos mixtos entre Hordas y Alianzas?\nEsto es útil para cuando hay poca población en el servidor poder hacer mazmorras o raids conjuntamente." 12 51
					if [ $? = 0 ]; then
						sed -e "s/AllowTwoSide.Interaction.Group = 0/AllowTwoSide.Interaction.Group = 1/g" -i $server_vmangos/etc/mangosd.conf.temp
					fi

					dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 9/23\n\n¿Quieres que se pueda interactuar en las subastas entre Hordas y Alianzas?\nEsto es útil para cuando hay poca población en el servidor." 12 51
					if [ $? = 0 ]; then
						sed -e "s/AllowTwoSide.Interaction.Auction = 0/AllowTwoSide.Interaction.Auction = 1/g" -i $server_vmangos/etc/mangosd.conf.temp
					fi

					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nOpción 10/23\n\nRATES DEL SERVIDOR:\n\nLos rates son lo que determinan lo rápido que se avanza en el juego.\nLos servidores de Blizzard tienen un rate de x1 por lo que si nosotros ponemos rates x3 se multiplican los valores al triple.\nEjemplo: Ponemos rates de experiencia al matar bichos x3. Si al nivel 10 para subir al 11 debemos matar 30 zebras en el de Blizzard, al nuestro con 10 ya sería suficiente." 22 60
					clear

					conf17=$(dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 11/23\n\nRATES DEL SERVIDOR:\nRates de objetos mediocres(grises)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Poor             = 1/Rate.Drop.Item.Poor             = $conf17/g" -i $server_vmangos/etc/mangosd.conf.temp

					conf18=$(dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 12/23\n\nRATES DEL SERVIDOR:\nRates de objetos normales(blancos)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Normal           = 1/Rate.Drop.Item.Normal           = $conf18/g" -i $server_vmangos/etc/mangosd.conf.temp

					conf19=$(dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 13/23\n\nRATES DEL SERVIDOR:\nRates de objetos poco frecuentes(verdes)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Uncommon         = 1/Rate.Drop.Item.Uncommon         = $conf19/g" -i $server_vmangos/etc/mangosd.conf.temp

					conf20=$(dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 14/23\n\nRATES DEL SERVIDOR:\nRates de objetos raros(azules)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Rare             = 1/Rate.Drop.Item.Rare             = $conf20/g" -i $server_vmangos/etc/mangosd.conf.temp

					conf21=$(dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 15/23\n\nRATES DEL SERVIDOR:\nRates de objetos épicos(morados)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Epic             = 1/Rate.Drop.Item.Epic             = $conf21/g" -i $server_vmangos/etc/mangosd.conf.temp

					conf22=$(dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 16/23\n\nRATES DEL SERVIDOR:\nRates de objetos legendarios(anaranjados)" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Legendary        = 1/Rate.Drop.Item.Legendary        = $conf22/g" -i $server_vmangos/etc/mangosd.conf.temp

					conf23=$(dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 17/23\n\nRATES DEL SERVIDOR:\nRates de objetos artefactos" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Artifact         = 1/Rate.Drop.Item.Artifact         = $conf23/g" -i $server_vmangos/etc/mangosd.conf.temp

					conf24=$(dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 18/23\n\nRATES DEL SERVIDOR:\nRates de objetos de misión" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Item.Referenced = 1/Rate.Drop.Item.Referenced = $conf24/g" -i $server_vmangos/etc/mangosd.conf.temp

					conf25=$(dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 19/23\n\nRATES DEL SERVIDOR:\nRates de dinero" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.Drop.Money                 = 1/Rate.Drop.Money                 = $conf25/g" -i $server_vmangos/etc/mangosd.conf.temp

					conf26=$(dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 20/23\n\nRATES DEL SERVIDOR:\nRates experiencia por muertes" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.XP.Kill    = 1/Rate.XP.Kill    = $conf26/g" -i $server_vmangos/etc/mangosd.conf.temp

					conf27=$(dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 21/23\n\nRATES DEL SERVIDOR:\nRates experiencia en misiones" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.XP.Quest   = 1/Rate.XP.Quest   = $conf27/g" -i $server_vmangos/etc/mangosd.conf.temp

					conf28=$(dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--inputbox "\nOpción 22/23\n\nRATES DEL SERVIDOR:\nRates experiencia por exploración" 12 51 1 2>&1 >/dev/tty)
					sed -e "s/Rate.XP.Explore = 1/Rate.XP.Explore = $conf28/g" -i $server_vmangos/etc/mangosd.conf.temp

					dialog --title "CONFIGURACIÓN DEL mangosd.conf" \
					--backtitle $backtitle \
					--yesno "\nOpción 23/23\n\n¿Deseas activar el acceso a la máquina por telnet?\nEsto es necesario si quieres tener una tienda de artículos en la web o gestionar el servidor remotamente." 12 51
					if [ $? = 0 ]; then
						sed -e "s/Ra.Enable = 0/Ra.Enable = 1/g" -i $server_vmangos/etc/mangosd.conf.temp
					fi

					### Configuraciones que cambiamos automáticamente:

					sed -e "s/Motd = \"Welcome to World of Warcraft!\"/Motd = \"Bienvenido a nuestro servidor. Esperamos que sea de tu agrado.\"/g" -i $server_vmangos/etc/mangosd.conf.temp

					#PidFile = "world.pid"  IMPRESCINDIBLE!!! NO TOCAR.  
					sed -e "s/PidFile = \"\"/PidFile = \"mangosd.pid\"/g" -i $server_vmangos/etc/mangosd.conf.temp

					cp $server_vmangos/etc/mangosd.conf.temp $server_vmangos/etc/mangosd.conf
					rm -f $server_vmangos/etc/mangosd.conf.temp
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nHas configurado el archivo worldserver.conf.\n\nSi los valores que has introducido son correctos ya puedes arrancar el servidor del juego." 10 50
					clear


####################################################################
# Configurar tabla realmlist de la base de datos realmd
####################################################################
				elif [ "$opcion235" = "3 - Configurar tabla realmlist de la base de datos realmd" ]; then
					rm -f $server_vmangos/etc/confrealmd.sql
					echo "REPLACE INTO \`realmlist\` (\`id\`,\`name\`,\`address\`,\`localAddress\`,\`port\`,\`icon\`,\`timezone\`,\`allowedSecurityLevel\`,\`population\`) VALUES
(1,'NombreReino','addressReino','127.0.0.1',portReino,1,1,0,0);" >> $server_vmangos/etc/confrealmd.sql
					
					conf1=$(dialog --title "CONFIGURACIÓN TABLA realmlist de la DB auth" \
					--backtitle $backtitle \
					--inputbox "\nNombre que le quieres dar a tu reino:" 10 51 Vanilla 2>&1 >/dev/tty)
					sed -e "s/NombreReino/$conf1/g" -i $server_vmangos/etc/confrealmd.sql

					conf2=$(dialog --title "CONFIGURACIÓN TABLA realmlist de la DB auth" \
					--backtitle $backtitle \
					--inputbox "\nDirección LAN de tu servidor. IMPRESCINDIBLE:" 10 51 $ipLocal 2>&1 >/dev/tty)
					sed -e "s/127\.0\.0\.1/$conf2/g" -i $server_vmangos/etc/confrealmd.sql

					conf3=$(dialog --title "CONFIGURACIÓN TABLA realmlist de la DB auth" \
					--backtitle $backtitle \
					--inputbox "\nIp externa de conexión a tu servidor. Si lo ejecutas en local deja el valor predeterminado:" 10 51 $ipLocal 2>&1 >/dev/tty)
					sed -e "s/addressReino/$conf3/g" -i $server_vmangos/etc/confrealmd.sql

					conf4=$(dialog --title "CONFIGURACIÓN TABLA realmlist de la DB auth" \
					--backtitle $backtitle \
					--inputbox "\nPuerto de conexión:" 10 51 8089 2>&1 >/dev/tty)
					sed -e "s/portReino/$conf4/g" -i $server_vmangos/etc/confrealmd.sql

					if [ -z "$realmd" ]; then
						realmd=$(dialog --title "DATOS DE CONEXIÓN" \
						--backtitle $backtitle \
						--nocancel \
						--inputbox "\nBase de datos auth: \nValor por defecto classic_realmd" 10 51 classic_realmd 2>&1 >/dev/tty)
					fi

					mysql -u${user} -p${pass} --port=${port} $realmd < $server_vmangos/etc/confrealmd.sql
					rm -f $server_vmangos/etc/confrealmd.sql
					dialog --title "INFORMACIÓN" \
					--backtitle $backtitle \
					--msgbox "\nYa tienes la Tabla realmlist configurada" 10 50
					clear
				fi


########  CONCLUSIÓN MENÚ Configuraciones varias  ########
				dialog --title "Menú de opciones --- Creado por MSANCHO" \
				--backtitle $backtitle \
				--nocancel \
				--menu "\nConfiguraciones varias" 20 80 8 \
				"1 - Configurar realmd.conf" "" \
				"2 - Configurar mangosd.conf" "" \
				"3 - Configurar tabla realmlist de la base de datos realmd" "" \
				"0 - Volver" "" 2> var235
		  
				opcion235=$(cat var235)
				rm var235
				done
			fi


########  CONCLUSIÓN MENÚ Vanilla MaNGOS 1.2/1.12  ######## 
			dialog --title "Menú de opciones --- Creado por MSANCHO" \
			--backtitle $backtitle \
			--nocancel \
			--menu "\nOpciones disponibles:" 20 80 11 \
			"1 - Obtención o actualización de todos los archivos necesarios" "" \
			"2 - Compilar el emulador" "" \
			"3 - DBC's, maps y vmaps - Descarga y colocación en directorio" "" \
			"4 - Instalar y actualizar las Bases de Datos" "" \
			"5 - Configuraciones varias" "" \
			"0 - Volver" "" 2> ~/var23
	  
			opcion23=$(cat ~/var23)
			rm ~/var*
			done
		fi


########  CONCLUSIÓN MENÚ Emuladores disponibles  ######## 
		dialog --title "Menú de opciones --- Creado por MSANCHO" \
		--backtitle $backtitle \
		--nocancel \
		--menu "\nEmuladores disponibles" 20 60 8 \
		"1 - TrinityCore WotLK 3.3.5" "" \
		"2 - AzerothCore WotLK 3.3.5" "" \
		"3 - Vanilla MaNGOS 1.2/1.12" "" \
		"0 - Volver" "" 2> ~/var2
	  
		opcion2=$(cat ~/var2)
		rm ~/var*
		done
	fi

#####################################################################################################
# FINAL Menú principal
#####################################################################################################
dialog --title "Menú de opciones --- Creado por MSANCHO" \
--backtitle $backtitle \
--nocancel \
--menu "\nMenú principal:" 20 80 11 \
"i - Información - Guía de uso" "" \
"1 - Preparación del sistema - Esenciales" "" \
"2 - Emuladores disponibles" "" \
"3 - Copias de seguridad de las Bases de Datos - PRÓXIMAMENTE" "" \
"4 - Conexión por Telnet a nuestro servidor - PRÓXIMAMENTE" "" \
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