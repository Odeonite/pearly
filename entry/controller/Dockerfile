FROM perl:5.28

RUN curl -L https://cpanmin.us | perl - App::cpanminus
RUN cpanm Mojolicious Mojo::Pg

COPY app.pl /app/entry.pl

CMD ["perl", "/app/entry.pl"]