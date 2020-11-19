# File shows how to clean up after apt-get command
#
# Usage:
#           Run the clean commands after you ran the original apt commands

FROM ubuntu
RUN {apt commands} \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*