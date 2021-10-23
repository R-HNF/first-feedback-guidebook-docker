FROM ghcr.io/vvakame/review:5.2

RUN mkdir -p /usr/share/man/man1

RUN apt-get update \
    && apt-get install -y \
        texlive-binaries \
        texlive-lang-japanese \
        texlive-latex-recommended \
        texlive-latex-extra \
        imagemagick \
        ruby-dev \
        build-essential \
        pdftk \
        git \
        curl \
        vim \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler unicode-display_width

WORKDIR /root
RUN git clone https://github.com/kmuto/review.git
WORKDIR /root/review
RUN bundle install --path vendor/bundle \
    && rake build \
    && gem install pkg/review-*.gem

WORKDIR /root
RUN git clone -b enhanced https://github.com/piroor/easybooks.git
WORKDIR /root/easybooks
RUN npm install \
    && npm run build \
    && npm install -g .

WORKDIR /root