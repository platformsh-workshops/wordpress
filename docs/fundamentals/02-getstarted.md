<div align="center">
    <img title="a title" alt="Alt text" src="../images/github/git-hub-examples.png">
    <br/><br/>
    <h1>Platform.sh fundamentals for Django</h1>
    <h4>Getting started</h4>
</div>

## Contents

- [Get the code](#get-the-code)
- [Running the app locally](#running-the-app-locally)

## Get the code

Let's set up your copy of the repository for the workshop.

1. Clone this repository

    ```bash
    git clone git@github.com:platformsh-workshops/django.git
    ```

1. Create a new repository on GitHub, either through the UI, or with the GitHub CLI tool:

    ```bash
    gh repo create <YOUR_ACCOUNT>/django --public
    ```

1. Push the clone to your remote repository:

    ```bash
    cd django
    git remote rename origin upstream
    git remote add origin git@github.com:<YOUR_ACCOUNT>/django.git
    git push -u origin main
    ```

## Running the app locally

Now that you have the repository locally and remotely on GitHub, let's use Docker to take a look at it running locally.
 
1. Install requirements using `pipenv`:

   ```bash
   cd django
   pipenv install
   ```

1. Install PostgreSQL requirements (`pyscopg2`) if needed (You will see a `pg_config_executable not found` error during installation if needed):

   ```bash
   > brew install postgresql           # MacOS
   > sudo apt-get install postgresql   # Ubuntu
   ```

1. Start the PostgreSQL container:

    ```bash
    docker-composer up -d
    ```

1. Create the database:

    This repository's `settings.py` configures the database credentials by default as follows:

    ```python
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql',
            'NAME': 'bigfoot',
            'USER': 'bigfoot',
            'PASSWORD': 'bigfoot',
            'HOST': 'localhost',
            'PORT': '5432',
        }
    }
    ```

    Create the `bigfoot` database and user in the PostgreSQL container:

    ```bash
    > sudo -u postgres psql
    postgres> createdb bigfoot && createuser -s bigfoot
    ```

1. Perform migrations:

    ```bash
    pipenv run python manage.py migrate
    ```

1. Generate starter data in the database:

    ```bash
    pipenv run python manage.py generate_fake_data
    ```

1. Run the server

    ```bash
    pipenv run python manage.py runserver
    ```

<div align="center">
    <br/>
    <img title="a title" alt="Alt text" src="../images/app-preview.png">
    <p width="60%"><em><strong>The workshop application running locally.</strong> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nibh odio, finibus a accumsan congue, posuere vitae dolor.</em></p>
    <br/>
</div>

<div align="right">
    <br/>
    <hr>
    <h3><a href="03-platformsh.md">Time to deploy!</a></h3>
</div>
