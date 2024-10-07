# Enable the transform secret engine
vault secrets enable transform

# Create the custom Template 
vault write transform/template/phone-number-tmpl type=regex \
    pattern="\+\d{1,2} (\d{3})-(\d{3})-(\d{4})" \
    alphabet=builtin/numeric

# Create masking
vault write transform/transformations/masking/phone-number-masking \
    template=phone-number-tmpl \
    masking_character=# \
    allowed_roles='*'

# Create transformation
vault write transform/transformations/fpe/phone-number \
    template=phone-number-tmpl \
    tweak_source=internal \
    allowed_roles='*'

vault write transform/role/telephone transformations=phone-number-masking,phone-number

vault write transform/encode/telephone value="+1 123-345-5678" transformation=phone-number

vault write transform/encode/telephone value="+1 123-345-5678" transformation=phone-number-masking


