#!/bin/sh
sudo clear
sudo apt-get update
git clone https://github.com/samBCortes/Test-AWS
cd testAWS
sudo apt install python3-pip -y
sudo pip3 install -r requirements.txt

# Configuración
PROYECTO_DIR="./testAWS"
SERVICE_NAME="test-server"

# Verificar que el directorio exista
if [ ! -d "$PROYECTO_DIR" ]; then
  echo "$PROYECTO_DIR no ha sido encontrado."
  exit 1
fi

# Crear archivo de servicio
cat << EOF | sudo tee /etc/systemd/system/$SERVICE_NAME.service > /dev/null
[Unit]
Description=Django
After=network.target

[Service]
User=root
Group=www-data
WorkingDirectory=$PROYECTO_DIR
ExecStart=/usr/bin/python3 $PROYECTO_DIR/manage.py runserver 0.0.0.0:80
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Recargar systemd
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

# Habilitar y iniciar el servicio
sudo systemctl enable $SERVICE_NAME
sudo systemctl start $SERVICE_NAME

echo "El servicio '$SERVICE_NAME' ha sido creado e inicializado."