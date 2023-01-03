FROM archlinux:latest
RUN pacman -Syy --noconfirm && \
	pacman -S --needed --noconfirm \
	git jq aurpublish nvchecker make pacman-contrib vim \
	sudo && \
	pacman -Scc --noconfirm

RUN useradd -m -g wheel makepkg && \
	echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER makepkg

CMD ["/bin/bash"]
