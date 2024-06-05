FROM fluent/fluentd:v1.16.2-debian-1.1

# Use root account to use apt
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN buildDeps="sudo make gcc g++ libc-dev"
RUN apt-get update && apt-get install -y --no-install-recommends $buildDeps
RUN gem install fluent-plugin-rewrite-tag-filter && gem install fluent-plugin-multi-format-parser
RUN gem sources --clear-all
RUN SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

USER fluent

ENTRYPOINT ["tini",  "--", "/bin/entrypoint.sh"]
CMD ["fluentd"]