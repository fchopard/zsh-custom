#!/usr/bin/zsh

# Remove any java installation bin directory from the current PATH
function dev-remove-java-from-path() {    
    remove-value-from-path $J6_HOME/bin
    remove-value-from-path $J7_HOME/bin    
    remove-value-from-path $J8_HOME/bin    
}

# Add a java installation to the PATH and set the JAVA_HOME
function dev-use-java-x() {
    local javaToUse=$1

    dev-remove-java-from-path
    export JAVA_HOME=$javaToUse
    prepend-to-path $JAVA_HOME/bin
    echo "-- Now using JAVA_HOME=$JAVA_HOME"
    java -version    
}

# Set java 6 as the current java installation
function dev-use-java-6() {
    dev-use-java-x $J6_HOME
    export MAVEN_OPTS="-Xmx2048m -Xms256m -XX:+UseConcMarkSweepGC -XX:MaxPermSize=512m"
}

# Set java 7 as the current java installation
function dev-use-java-7() {
    dev-use-java-x $J7_HOME
    export MAVEN_OPTS="-Xmx2048m -Xms256m -XX:+UseConcMarkSweepGC -XX:MaxPermSize=512m"
}

# Set java 8 as the current java installation
function dev-use-java-8() {
    dev-use-java-x $J8_HOME
    export MAVEN_OPTS="-Xmx3072m -Xms256m -XX:+UseConcMarkSweepGC"
}

# Set hybris ant environment
function dev-hybris-set-ant-env() {
    export ANT_OPTS="-Xmx200m"
    export ANT_HOME=$PWD/apache-ant-1.8.2
    chmod +x "$ANT_HOME/bin/ant"
    prepend-to-path $ANT_HOME/bin

    echo "Setting ant home to: $ANT_HOME"
    ant -version
}

# Switch maven settings from central to nexus
function dev-switch-mvn-settings() {
    if [[ -f ~/.m2/settings.direct.xml ]]; then
        mv ~/.m2/settings.xml ~/.m2/settings.isa.xml
        mv ~/.m2/settings.direct.xml ~/.m2/settings.xml
        echo "Maven settings.xml is now using central repo"
    else
        mv ~/.m2/settings.xml ~/.m2/settings.direct.xml
        mv ~/.m2/settings.isa.xml ~/.m2/settings.xml
        echo "Maven setttings.xml is now using nexus"
    fi
}

# Recursively traverse directory tree for git repositories, run git command
# e.g.
#   gittree status
#   gittree diff
# from: http://chr4.org/blog/2014/09/10/gittree-bash-slash-zsh-function-to-run-git-commands-recursively/
gittree() {
  if [ $# -lt 1 ]; then
    echo "Usage: gittree <command>"
    return 1
  fi

  for gitdir in $(find . -type d -name .git); do
    # Display repository name in blue
    repo=$(dirname $gitdir)
    echo -e "\033[34m$repo\033[0m"

    # Run git command in the repositories directory
    cd $repo && git $@
    ret=$?

    # Return to calling directory (ignore output)
    cd - > /dev/null

    # Abort if cd or git command fails
    if [ $ret -ne 0 ]; then
      return 1
    fi

    echo
  done
}
