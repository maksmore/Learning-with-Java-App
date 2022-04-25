# This repository is designed to deploy infrastructure in AWS from scratch

The project was developed as a degree project at the end of the [TeachMeSkills](https://teachmeskills.by/kursy-programmirovaniya/kursy-dev-ops-online?utm_source=google&utm_medium=cpc&utm_campaign=s_devops&utm_content=ad1&utm_term=%2Bdevops%20%2B%D0%BA%D1%83%D1%80%D1%81%D1%8B&roistat=google4_g_102404084552_439370431586_%2Bdevops%20%2B%D0%BA%D1%83%D1%80%D1%81%D1%8B&roistat_referrer=&roistat_pos=&gclid=CjwKCAiAp8iMBhAqEiwAJb94z_rbVRBa8hSMzZPK6v6K0gGnbP1A5UFcDoZVxw4qoLg8WwdZh7hTChoCPY8QAvD_BwE) course.  

The application solves the task of obtaining the necessary skills for IT specialists of different directions, currently 2 options are available:

* `maintenance`
* `developer`

The solution works only in the `us-east-1` region because of it's hardcode.

## Prerequisites

### Variables

Export your credentials to environment variables.
By default, the `username` and `password` values for the database have the values `postgres` and `password`, respectively. You also need to specify the unique name of your AWS RDS database. For your own purposes, this value can be changed in *`it-specialty/src/main/java/by/morozov/its/controller/SpecialtyController.java`*

**Requirements:**  
| Environment variables |
|:----------------------|
|`AWS_ACCESS_KEY_ID`|
|`AWS_SECRET_ACCESS_KEY`|
|`AWS_DEFAULT_REGION`|
|`TF_VAR_aws_access_key_id`|
|`TF_VAR_aws_default_region`|
|`TF_VAR_aws_secret_access_key`|
|`TF_VAR_db_password`|
|`TF_VAR_your_dns_name`|
|`TF_VAR_account_id`|
|`TF_VAR_email_for_alarm`|

Before running you need also to add variable values to the Github Actions Secrets. The values for `POSTGRES` are the same as written above:

| GitHub Actions Secrets |
| ------------------------ |
| `POSTGRES_USER` |
| `POSTGRES_PASSWORD` |
| `POSTGRES_DATABASE` |
| `SPRING_DATASOURCE_USERNAME` |
|`SPRING_DATASOURCE_PASSWORD`|
| `AWS_ACCESS_KEY_ID` |
| `AWS_SECRET_ACCESS_KEY` |

### Notification

To receive notifications in the Telegram you need to create a bot get a Token and make a request of bot chat ID. Then add these things to Github Actions Secrets:
| Github Actions Secrets |
| ---------------------- |
| `TELEGRAM_TO` |
| `TELEGRAM_TOKEN` |

[This action](https://github.com/appleboy/telegram-action) was used to implement CI/CD notifications. You can also read the documentation there.

For security reasons, it's also recommended to create a separate *`AWS User`* for GitHub actions and give him full access policy to work only with the required services such as AWS ECS, AWS ECR. Add `AWS_ACCESS_KEY` & `AWS_SECRET_KEY` to the GitHub Actions Secrets to perform ci/cd processes.

### Usage

To get the data, you need to send a POST request, for example:
>       curl -s -H "Content-Type: application/json" -X POST -d '{"name": "developer"}' https://your_domain/api/v1/specialty
Or if you've already install `jq` you can run the following command and get a sorted result:
>       curl -s -H "Content-Type: application/json" -X POST -d '{"name": "maintenance"}' https://your_domain/api/v1/specialty | jq '.technologies[].name'
The application also accepts simple GET requests by command:
>       curl -s https://your_domain/api/v1/specialty

***

**Status of Last App Deployment:**

![cd workflow](https://github.com/maksmore/Learning-with-TeachMeSkills/actions/workflows/cd.yml/badge.svg)  
![ci workflow](https://github.com/maksmore/Learning-with-TeachMeSkills/actions/workflows/ci.yml/badge.svg)  

Developed by *maksmore*
