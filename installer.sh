#!/bin/bash

# 2011/08/26 jiwasaki
# Text::MeCab Installer ver 1.01


# TODO set your install directory.
ROOT_DIR=${ROOT_DIR:?"Set ROOT_DIR env variable"}
INSTALL_DIR=$ROOT_DIR/mecab
EXTLIB=$ROOT_DIR/extlib

mkdir tmp
cd tmp

# create install directory.
if [ -d $INSTALL_DIR ]; then 
    echo "Already exist install directory."
else
    mkdir $INSTALL_DIR
fi

if [ -d $EXTLIB ]; then 
    ehcho "Already exist extlib."
else
    mkdir $EXTLIB
fi


# install MeCab 0.98
if [ -e $INSTALL_DIR/bin/mecab-config ]; then 
    
    echo "Already installed MeCab."

else

    wget 'http://mecab.googlecode.com/files/mecab-0.991.tar.gz'
    tar zxvf 'mecab-0.991.tar.gz'
    cd 'mecab-0.991'
    ./configure --prefix=$INSTALL_DIR --enable-utf8
    make 
    make install
    cd ..

fi


# install ipa-dictionaly 2.7.0
if [ -d $INSTALL_DIR/lib/mecab/dic/ipadic ]; then

    echo "Already installed IPA MeCab Dictionary."

else 
    
    wget 'http://downloads.sourceforge.net/project/mecab/mecab-ipadic/2.7.0-20070801/mecab-ipadic-2.7.0-20070801.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fmecab%2Ffiles%2Fmecab-ipadic%2F2.7.0-20070801%2F&ts=1314179788&use_mirror=cdnetworks-kr-1'
    tar zxvf 'mecab-ipadic-2.7.0-20070801.tar.gz'
    cd 'mecab-ipadic-2.7.0-20070801'
    ./configure --prefix=$INSTALL_DIR --with-mecab-config="$INSTALL_DIR/bin/mecab-config" --with-charset=utf-8
    make 
    make install
    cd ..

fi


# install Text::MeCab
# configure option :
#   1) choice mecab-config directory ( $INSTALL_DIR/bin/mecab-config )
#   2) choice character set ( utf8 )
export PERL5LIB=$EXTLIB

wget 'http://cpan.cpantesters.org/authors/id/D/DA/DAGOLDEN/ExtUtils-ParseXS-2.21.tar.gz'
cpanm -L $EXTLIB './ExtUtils-ParseXS-2.21.tar.gz' # install old ExtUtils::ParseXS
LD_LIBRARY_PATH="$INSTALL_DIR/lib" cpanm --prompt --interactive -L $EXTLIB Text::MeCab

cpanm -L $EXTLIB ExtUtils::ParseXS # update latest ExtUtils::PaeseXS


# auto clear
cd ..
rm -rf tmp
