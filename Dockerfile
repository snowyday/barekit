FROM nvidia/cuda:9.0-cudnn7-devel
MAINTAINER snowyday

# User
ENV USER user
ENV PASS user

# Libs
RUN apt-get update
RUN apt-get -y install sudo language-pack-ja openssh-server zsh \
            vim git curl wget emacs htop automake build-essential \
	    pkg-config libevent-dev libncurses5-dev tmux lsof
    
# Lc_ALL: cannot change locale (ja_JP.UTF-8)
RUN locale-gen ja_JP.UTF-8

# could not load host key: /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key
RUN /etc/init.d/ssh restart

# User
RUN adduser $USER
RUN gpasswd -a $USER sudo
RUN echo "$USER:$PASS" | chpasswd

# Set user
USER $USER
WORKDIR /home/$USER

# Prezto
RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
RUN ln -s ~/.zprezto/runcoms/zlogin ~/.zlogin
RUN ln -s ~/.zprezto/runcoms/zlogout ~/.zlogout
RUN ln -s ~/.zprezto/runcoms/zpreztorc ~/.zpreztorc
RUN ln -s ~/.zprezto/runcoms/zprofile ~/.zprofile
RUN ln -s ~/.zprezto/runcoms/zshenv ~/.zshenv
RUN ln -s ~/.zprezto/runcoms/zshrc ~/.zshrc

# Set root for sshd and shell
USER root
RUN chsh -s /bin/zsh $USER

# SSH start
CMD ["/usr/sbin/sshd", "-D"]
