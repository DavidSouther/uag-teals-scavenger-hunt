# How to start a new project from Angular Base

# Setup

Clone the repository and `cd` to the directory.

    git clone ssh://git@stash.novus.local:2022/aloha/nv-chrome.git
    cd nv-chrome

## Install Node, Grunt, and Bower

Install Node using [nvm][nvm]. Use the 0.10 line of node releases.

    curl https://raw.github.com/creationix/nvm/master/install.sh | sh
    nvm install 0.10
    nvm alias default 0.10
    nvm use default

From NVM:

> The script clones the nvm repository to ~/.nvm and adds the source line to
> your profile (`~/.bash_profile or ~/.profile`).

You will want to add the `nvm use default` line to your `~/.bash_profile`,
`~/.bashrc`, or similar. From this point, you have node installed and running.
If you have any issues, refer to the nvm docs.

Install grunt-cli and bower from npm. This will make the `grunt` and `bower`
commands available globally.

    npm install --global grunt-cli bower

From the project root, install the project dependencies.

    npm install

1. Perform project Genesis
    1. Change README.md

    1. Edit half-dozen places with `name`
        1. package.json
        1. bower.json
        1. src/client/index.jade
            * `Title` line 7
            * `ng-app` line 16
        1. src/client/main/main.coffee
        1. src/client/main/test.coffee
        1. src/client/Gruntfile.coffee
          * `module` line 4
        1. src/features/integration/users/App/smoke.feature

    1. Grunt :)

    1. git commit

    1. Rebase from root, squashing all commits.

1. Configure new remotes
    1. remote add upstream ssh://repo
    1. git push upstream master
    1. fork 'new repo' on Stash

    1. remote add origin ssh://fork


# Ongoing

1. git branch
    * aloha-xxx/ShortDescription -- Any task with a story in JIRA
    * foundation/ShortDesc -- Work relating to building out the foundation
    * refactor/ShortDesc -- Work captuing a specific refactor
    * bug/ShortDesc -- Work in fixing a bug
    * doc/ShortDesc -- Work in adding documentation

1. Iterate - grunt, feature, test, (server?), client

    1. `$ grunt`
    1. Create new scenario
        1. In `src/features/interation/users/...`
        1. Create new or use existing client
        1. Create new or use existing feature
        1. Create new scenario
    1. `$ grunt`
    1. While failing:
        1. Define new steps
        1. Grunt until passed, editing feature and steps until good API
    1. `$ git commit -am 'Feature test for such and such.'`
    1. If new server resources needed
        1. Unit test in Server (Using Supertest)
        1. Write feature code
        1. Grunt, iterating on API and Impl till it works
        1. `$ git commit -am 'Server resources for feature.'`
    1. Create client resources
        1. Write one single (small) test case
        1. Grunt, expecting failure
        1. Write smallest code to pass test
        1. `$ git commit -m 'Desc of code, with tests.'`
        1. Grunt, with pass
        1. Next test, grunt, impl, grunt, commit...
        1. Repeat until Feature passes
    1. Pull from master to masteru
    1. Merge or rebase from master to feature (Dev's choice, until team decides
        which is better.)
    1. git push -u origin feature
        * **Never push to master!**
    1. Open Pull Request
        1. Fix issues as team comments, following these steps.
        1. Any PRs without tests will be declined immediately.
        1. When all devs Approve, PR Owner can merge.
    1. Pull master - should ALWAYS be a fast forward.

## Updating Code

Every time you update code (eg after pulling latest master), prepare the code
for deployment.

    npm install
    grunt deploy

# Run a Local Development Server

After running `grunt deploy`, the application can be run without a backend using
stubbed data. From the project root, run:

    npm start &

This will start an http server on an open port (search starting at 1024), and
prints a banner on the command line.


## Running full feature test suite

To run the entire feature test suite, run grunt from the project root.

    grunt

This will run nv-chrome-specific unit tests, nv-chrome dev server tests, and the
entire nv-aloha feature test suite (using static test data).

# Connecting to Alpha App

After configuring and starting the [Alpha App][alohaapp], attaching the nv-chrome front end is as simple as creating a symlink from `/nv/www/aloha` to `./build/client` and navigating to [http://localhost:8000/](http://localhost:8000/). It is an alpha dev environment, so the username/password is `dev@novus.com`/`dev`.

Creating the symlink probably requires root access, and might need a trip to ITSupport.

[nvm]: https://github.com/creationix/nvm
