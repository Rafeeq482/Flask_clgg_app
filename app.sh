user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y git
    apt-get install -y python3 python3-pip
    git clone https://github.com/Rafeeq482/Flask_clgg_app.gitt /home/ubuntu/Flask_clgg_app
    cd /home/ubuntu/Flask_clgg_app
    pip3 install -r requirements.txt
    python3 app.py  # Or your entry script
  EOF