
PELICAN=pelican
PELICANOPTS=None

BASEDIR=$(PWD)
INPUTDIR=$(BASEDIR)/src
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelican.conf.py
THEME=pelican-course-theme


SSH_HOST=web
SSH_TARGET_DIR=markbetnel.com/genphys

DROPBOX_DIR=~/Dropbox/Public/

help:
	@echo 'Makefile for a pelican Web site                                       '
	@echo '                                                                      '
	@echo 'Usage:                                                                '
        @echo '   make all                         generate the site and upload it   '
	@echo '   make html                        (re)generate the web site         '
	@echo '   make clean                       remove the generated files        '
	@echo '   ssh_upload                       upload the web site using SSH     '
	@echo '                                                                      '

all: html ssh_upload

html: clean $(OUTPUTDIR)/index.html
	@echo 'Done'

$(OUTPUTDIR)/%.html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) -t $(THEME)

clean:
	rm -fr $(OUTPUTDIR)
	mkdir $(OUTPUTDIR)


ssh_upload: $(OUTPUTDIR)/index.html
	scp -r $(OUTPUTDIR)/* $(SSH_HOST):$(SSH_TARGET_DIR)


github: $(OUTPUTDIR)/index.html
	ghp-import $(OUTPUTDIR)
	git push origin gh-pages

todo: 
	grep -r TODO src/

.PHONY: html help clean ftp_upload ssh_upload dropbox_upload github
    
