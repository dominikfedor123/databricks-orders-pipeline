{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set environment = var('deployment_env', target.name) -%}

    {%- if environment == 'dominik' -%}

        {{ target.schema }}

    {%- elif environment == 'dev' -%}

        {%- if custom_schema_name is not none -%}
            {{ custom_schema_name | trim }}_dev
        {%- else -%}
            {{ target.schema }}
        {%- endif -%}

    {%- elif environment == 'prod' -%}

        {%- if custom_schema_name is not none -%}
            {{ custom_schema_name | trim }}_prod
        {%- else -%}
            {{ target.schema }}
        {%- endif -%}

    {%- else -%}

        {{ target.schema }}

    {%- endif -%}

{%- endmacro %}
