# To view generated pkgdown files (also open http://localhost:3000 in browser):
#  docker build -t trevorld/pkgdown-png .
#  docker run --rm -p 3000:3000 trevorld/pkgdown-png
#  http://localhost:3000/reference/transformationGrob.html#examples

FROM rocker/r-base
COPY DESCRIPTION DESCRIPTION
COPY NAMESPACE NAMESPACE
COPY _pkgdown.yml _pkgdown.yml
COPY R R
COPY man man

RUN apt-get update && apt-get install -y  \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
    libharfbuzz-dev libfribidi-dev \
    libssl-dev \
    libxml2-dev \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

RUN Rscript -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_github("r-lib/pkgdown")'
RUN Rscript -e 'pkgdown::build_site()'

CMD python3 -m http.server 3000 --directory /docs/dev/
