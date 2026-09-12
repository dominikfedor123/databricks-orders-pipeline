{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- if target.name == 'dominik' -%}

        {{ target.schema }}

    {%- elif target.name == 'dev' -%}

        {%- if custom_schema_name is not none -%}
            {{ custom_schema_name | trim }}_dev
        {%- else -%}
            {{ target.schema }}
        {%- endif -%}

    {%- elif target.name == 'prod' -%}

        {%- if custom_schema_name is not none -%}
            {{ custom_schema_name | trim }}_prod
        {%- else -%}
            {{ target.schema }}
        {%- endif -%}

    {%- else -%}

        {{ target.schema }}

    {%- endif -%}

{%- endmacro %}
