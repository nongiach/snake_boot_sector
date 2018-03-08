SIZE=512

NAME	= snake.img

all	:
	nasm mbr.s
	nasm snake.s
	cat mbr snake /dev/zero | dd of=$(NAME) bs=512 count=2280

sdb	:
	sudo dd bs=512 if=$(NAME) of=/dev/sdb

dis	:
	ndisasm -b 16 $(NAME)

fclean clean	:
	rm -f $(NAME) mbr snake

re	: fclean all

