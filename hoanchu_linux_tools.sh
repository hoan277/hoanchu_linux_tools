#!/bin/bash

# Hàm tạo giao diện menu
show_menu() {
    tab=$'\t\t\t'
    echo -e " ╔══════════════════════════════════════════════════════════════════════════════╗"
    echo -e " ║  @name:             Hoan Chu Linux Tools                                     ║"
    echo -e " ║  @version:          1.0                                                      ║"
    echo -e " ║  @date_release:     08/03/2024                                               ║"
    echo -e " ║  @author:           Hoan Chu                                                 ║"
    echo -e " ║  @credit:                                                                    ║"
    echo -e " ║                                                                              ║"
    echo -e " ║  Chào mừng bạn đến với tools cài đặt và sửa chữa hệ thống phần mềm cho Linux ║"
    echo -e " ║                                                                              ║"
    echo -e " ╠═════════════════════════════════ I. CÀI ĐẶT ═════════════════════════════════╣"
    echo -e " ║  1. Cài đặt ffmpeg gốc                                                       ║"
    echo -e " ║  2. Cài đặt ffmpeg static                                                    ║"
    echo -e " ║  3. Cài đặt CUDA Toolkit                                                     ║"
    echo -e " ║  4. Cài đặt NVIDIA Driver                                                    ║"
    echo -e " ║  5. Dọn rác Linux                                                            ║"
    echo -e " ║  6. Cài đặt python + pip                                                     ║"
    echo -e " ║  7. Xóa log Docker                                                           ║"
    echo -e " ║  8. Cài đặt Netdata                                                          ║"
    echo -e " ║  9. .................................................                        ║"
    echo -e " ║ 10. .................................................                        ║"
    echo -e " ╠════════════════════════════════ II. XÓA RÁC ═════════════════════════════════╣"
    echo -e " ║ 11. .................................................                        ║"
    echo -e " ║ 12. .................................................                        ║"
    echo -e " ║ 13. .................................................                        ║"
    echo -e " ║ 14. .................................................                        ║"
    echo -e " ║ 15. .................................................                        ║"
    echo -e " ║ 16. .................................................                        ║"
    echo -e " ║ 17. .................................................                        ║"
    echo -e " ║ 18. .................................................                        ║"
    echo -e " ║ 19. .................................................                        ║"
    echo -e " ║ 20. .................................................                        ║"
    echo -e " ╠════════════════════════════════ III. KHÁC   ═════════════════════════════════╣"
    echo -e " ║  q. Thoát chương tình - Ctrl+C                                               ║"
    echo -e " ╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e ""
    read -p " Nhập lựa chọn của bạn: " choice
    echo ""

    case $choice in
        1)
            install_ffmpeg
            ;;
        2)
            install_ffmpeg_static
            ;;
        3)
            install_cuda_toolkit
            ;;
        4)
            install_nvidia_driver
            ;;
        5)
            cleanup_linux
            ;;
        6)
            install_python_pip
            ;;
        7)
            clear_docker_log
            ;;
        8)
            install_netdata
            ;;
        q)
            echo " ════════════════════ Xin chào và hẹn gặp lại ════════════════════"
            exit 0
            ;;
        *)
            echo "Lựa chọn không hợp lệ. Vui lòng thử lại."
            show_menu
            ;;
    esac
}

# Cài đặt FFmpeg gốc
install_ffmpeg() {
    echo "Đang cài đặt FFmpeg gốc..."
    echo ""
    sudo apt-get install ffmpeg
    show_menu
}
# Cài đặt Netdata
install_netdata() {
    echo "Đang cài đặt Netdata..."
    echo ""
    cd /tmp/

    # Check if NVIDIA driver is installed
    read -p "Bạn đã cài đặt NVIDIA driver chưa? (Y/N): " answer
    if [[ $answer == [Nn]* ]]; then
        install_nvidia_driver
    fi

    sudo apt-get install -y debian-archive-keyring libbson-1.0-0 libmongoc-1.0-0 libnetfilter-acct1 netdata netdata-ebpf-code-legacy netdata-plugin-apps netdata-plugin-chartsd netdata-plugin-debugfs netdata-plugin-ebpf netdata-plugin-go netdata-plugin-logs-management netdata-plugin-network-viewer netdata-plugin-nfacct netdata-plugin-perf netdata-plugin-pythond netdata-plugin-slabinfo netdata-plugin-systemd-journal
    pip install nvidia-ml-py
    wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh && sh /tmp/netdata-kickstart.sh
    git clone https://github.com/coraxx/netdata_nv_plugin --depth 1
    sudo cp netdata_nv_plugin/nv.chart.py /usr/libexec/netdata/python.d/
    sudo cp netdata_nv_plugin/python_modules/pynvml.py /usr/libexec/netdata/python.d/python_modules/
    sudo cp netdata_nv_plugin/nv.conf /etc/netdata/python.d/
    sudo service netdata restart
    show_menu
}

# Cài đặt FFmpeg static
install_ffmpeg_static() {
    echo "Đang cài đặt FFmpeg static và cuda..."
    echo ""
    git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
    cd nv-codec-headers && sudo make install && cd –
    git clone https://git.ffmpeg.org/ffmpeg.git
    cd ffmpeg
    sudo apt-get install build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev
    ./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --disable-static --enable-shared
    make -j 8
    sudo make install
    sudo rm -rf /tmp/*
    show_menu
}

# Cài đặt CUDA Toolkit
install_cuda_toolkit() {
    echo "Đang cài đặt CUDA Toolkit version 12.4 update 08/03/2024..."
    echo ""
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
    sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
    wget https://developer.download.nvidia.com/compute/cuda/12.4.0/local_installers/cuda-repo-ubuntu2004-12-4-local_12.4.0-550.54.14-1_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu2004-12-4-local_12.4.0-550.54.14-1_amd64.deb
    sudo cp /var/cuda-repo-ubuntu2004-12-4-local/cuda-*-keyring.gpg /usr/share/keyrings/
    sudo apt-get update
    sudo apt-get -y install cuda-toolkit-12-4
    show_menu
}

# Cài đặt NVIDIA Driver
install_nvidia_driver() {
    echo "Đang cài đặt NVIDIA Driver..."
    echo ""
    sudo apt-get install -y cuda-drivers
    show_menu
}

# Dọn rác Linux
cleanup_linux() {
    echo "Đang dọn rác Linux..."
    echo ""
    sudo apt-get clean
    show_menu
}
clear_docker_log() {
    echo "Đang xóa log Docker..."
    echo ""
    sudo sh -c "truncate -s 0 /var/lib/docker/containers/*/*-json.log" 
    show_menu
}
# Hàm cài đặt Python và pip
install_python_pip() {
    echo "Đang cài đặt Python và pip..."
    echo ""
    sudo apt-get install python3
    sudo apt-get install python3-pip
    show_menu
}
# Chạy giao diện menu
show_menu