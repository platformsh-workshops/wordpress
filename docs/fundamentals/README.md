<div align="center">
    <img title="a title" alt="Alt text" src="../images/github/git-hub-workshops.png">
    <br/><br/>
    <h1>Platform.sh fundamentals for Django</h1>
    <h4>Setup and requirements</h4>
</div>

## Contents

- [About](#about)
- [Before the workshop](#before-the-workshop)

## About

DevOps engineers are often the sole key-holders of both environments and the understanding of how infrastructure dependencies are satisfied and updated. But what happens if they leave? And how easy are development environments to provision once you have hundreds of sites?

You’ll find those answers in this workshop, where you’ll approach DevOps differently for Django with Platform.sh. Each developer will configure infrastructure themselves with simple abstractions, and leverage tools they’re already using to provision environments on-demand.

### Outline

During this workshop, you will cover a number of topics that will take you from nothing to a full development workflow for a Django app running in production on Platform.sh.

1. Setup and requirements
1. Introduction to the workshop and Platform.sh
1. Getting started
1. Platform.sh configuration
1. Data and environments
1. Writing and reverting new features
1. Next steps

## Before the workshop

Before starting the workshop, there are a few requirements you will need to install and setup in order to follow the lesson.
Take a look at those requirements, then follow the steps listed below.

### Requirements

- [Python 3.9](python.org/downloads/)
- [A GitHub account](https://github.com/join)
- [Docker installed](https://www.docker.com/products/docker-desktop/)
- [pipenv installed](https://pypi.org/project/pipenv/)
- [A Platform.sh account](https://auth.api.platform.sh/register) 
- [The Platform.sh CLI installed locally](https://docs.platform.sh/administration/cli.html)

### Steps

1. Create a Platform.sh account.

    Platform.sh provides a free one month trial, which will provide all of the resources you will need to go through these Getting Started guides.

    Before starting, be sure to [register for a trial Platform.sh account](https://auth.api.platform.sh/register) if you have not done so already. You can use your email address to register, or you can sign up using an existing GitHub, Bitbucket, or Google account. If you choose this option, you will be able to set a password for your Platform.sh account later.

    You will be given an option to create a project at this point (two options: Use a template and Create from scratch). Click the Cancel button in the right-hand corner of the screen for now - you will create a project later in the workshop.

1. Install the Platform.sh CLI:

    In addition to a Platform.sh account, this workshop uses the Platform.sh CLI. The CLI is the primary, and the most useful, tool for deploying applications and interacting with your projects.

    ```bash
    curl -sS https://platform.sh/cli/installer | php
    ```

    > **Note:**
    >
    > On some Windows terminals, you may need `php.exe` instead of `php`.

1. Authenticate the CLI with your Platform.sh account:

    ```bash
    platform login
    ```

<div align="right">
    <br/>
    <hr>
    <h3><a href="01-introduction.md">Move on to the introduction</a></h3>
</div>