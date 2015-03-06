#!/bin/bash -xe

git clone https://git.openstack.org/openstack/sahara /tmp/sahara
cd /tmp/sahara
if [ "$ZUUL_BRANCH" != "master" ]; then
   git checkout "$ZUUL_BRANCH"
   sudo pip install -U -r requirements.txt
fi

if [[ "$JOB_NAME" =~ scenario ]]; then
  tox -e scenario --notest
  .tox/scenario/bin/pip install $WORKSPACE
else
  tox -e integration --notest
  .tox/integration/bin/pip install $WORKSPACE
fi

bash -x $WORKSPACE/sahara-ci-config/slave-scripts/gate-sahara.sh /tmp/sahara
