## Exercise 8 - Generating RSA Keys
Request and retrieve an RSA private key using an order.

For the Glance image signing and verification feature, the first step is to create an RSA key pair.  Then, the user should request a CA to create a certificate tied to the key pair.  Before the user uploads the image, they sign the image using the private key.  The user uploads the certificate to Barbican and adds the certificate UUID and the image signature to the image metadata.  When the image is uploaded, Glance will retrieve the certificate and use it to verify the signature of the image.  Nova can also be configured to verify the signature again before booting the image.

This exercise shows an example of creating an RSA key pair, and exercise 6 shows an example of uploading a certificate.

Submit an order for a 4096-bit RSA key pair.

    # ORDER_REF=$(openstack secret order create asymmetric \
          --algorithm rsa --bit-length 4096 \
          -c "Order href" -f value)

Once the order’s status changes to ACTIVE the order metadata will include a "Container href" for the newly created RSA Secret Container

    # RSA_CONTAINER_REF=$(openstack secret order get $ORDER_REF \
           -c "Container href" -f value)

Retrieve the public key and save it to a file:

    # PUBLIC_KEY_REF=$(openstack secret container get \
          $RSA_CONTAINER_REF -c "Public Key" -f value)
    # openstack secret get --file generated_rsa.pub $PUBLIC_KEY_REF
    # cat generated_rsa.pub
    -----BEGIN RSA PUBLIC KEY-----
    MIICCgKCAgEAslRbbSzN80EY2zO/Ji9poGotaVY9blRnsQU/W2WdohJdbGAMZD0j
    PbxuYBps83L7TlcXm5EaF7wle5sAI0xdOuY2Q6/i63oGsYoALvsLPh0mwEbpxFtL
    XF90gRJ8VotRrJBkqei4mHNbIkpeAkhHfZYp2J49mkA48KLixzgiB773WEWPR/dc
    EXTmXAkYEBB4o6qJJVP23eYFuy1bv2s2LsTMPf8F8tgaxQ0Wp487QSOwWPNdGewi
    HJUmz7Q4wOpkwP94quN7VyGd3ubSAK3uonJq6zPBSujioEPevblv22niN8Xi/KKB
    Tdwwy8Ry8+/8brLUW6P9UKT+ZQZ20GcDvN1fzBybp7Fc7Xv+idAdMHl3CcsGE6/y
    S/yfPKwYwLk6JlVqicD34F48Ydwa2NdsmBQ/HI11CYgv9cFFJ1dqHX/dl2WfLOz4
    TxA47/i1dGgkVp9BOniHDDjMvQtspHvMgA7d6JBwv2kfGRhPv8xxNFv7TcuA8bOH
    18RI9yq7Cn1mF/2YvxYsuiPva6FoKkkUKgZuixBNUzR8/mBJ1fY2SwDCjpe/usvS
    scceBS2B5cnMlslDm5fSuc3WpqjbYk/+wugSO9WUQ03650QB/byvW5jCU9VI48M0
    1GjwJdtN8DhMlhhYl/0moLijysuk03Y4l0KxH6Q+orlaNRJ+uRtL61ECAwEAAQ==
    -----END RSA PUBLIC KEY-----

Retrieve the private key and save it to a file:

    # PRIVATE_KEY_REF=$(openstack secret container get \
          $RSA_CONTAINER_REF -c "Private Key" -f value)
    # openstack secret get --file generated_rsa $PRIVATE_KEY_REF

Verify the contents of the file.

    # cat generated_rsa
    -----BEGIN PRIVATE KEY-----
    MIIJQQIBADANBgkqhkiG9w0BAQEFAASCCSswggknAgEAAoICAQCyVFttLM3zQRjb
    M78mL2mgai1pVj1uVGexBT9bZZ2iEl1sYAxkPSM9vG5gGmzzcvtOVxebkRoXvCV7
    mwAjTF065jZDr+LregaxigAu+ws+HSbARunEW0tcX3SBEnxWi1GskGSp6LiYc1si
    Sl4CSEd9linYnj2aQDjwouLHOCIHvvdYRY9H91wRdOZcCRgQEHijqoklU/bd5gW7
    LVu/azYuxMw9/wXy2BrFDRanjztBI7BY810Z7CIclSbPtDjA6mTA/3iq43tXIZ3e
    5tIAre6icmrrM8FK6OKgQ969uW/baeI3xeL8ooFN3DDLxHLz7/xustRbo/1QpP5l
    BnbQZwO83V/MHJunsVzte/6J0B0weXcJywYTr/JL/J88rBjAuTomVWqJwPfgXjxh
    3BrY12yYFD8cjXUJiC/1wUUnV2odf92XZZ8s7PhPEDjv+LV0aCRWn0E6eIcMOMy9
    C2yke8yADt3okHC/aR8ZGE+/zHE0W/tNy4Dxs4fXxEj3KrsKfWYX/Zi/Fiy6I+9r
    oWgqSRQqBm6LEE1TNHz+YEnV9jZLAMKOl7+6y9Kxxx4FLYHlycyWyUObl9K5zdam
    qNtiT/7C6BI71ZRDTfrnRAH9vK9bmMJT1UjjwzTUaPAl203wOEyWGFiX/SaguKPK
    y6TTdjiXQrEfpD6iuVo1En65G0vrUQIDAQABAoIB/xMn/Ko9peH7nC/v3xi6/x28
    SiSGnxK6/miFp8ipocVHM8Hwj2Q1LRP0qeao8As2zsgbku2jKKpkC6K7g8hG67zn
    /exHeJjTAuUPbfWeAhcqCn+dHn95Tx8dIea7lZ+2V4+x8x5NYYb+3UtRsceM/CEB
    gH1EglmPjI5M8Q91eDJc0TUqQ7n3WGyHojdAwtT27/6k0xavblVn4DW7KZ/mZGuh
    uE7wljMAA+AnB8f4GuVkcA0eF2Ixe3iWjRTCx1Xx1+DjkJLK3PT/J3ZKVUS9amUI
    5XNem+TwH2gX4lV/FgT72tEi8L8ytbEndhZtg+uwW+2ISEeP1iZTkwBHMXwxlLUH
    DmVHSVbXB3zu/bBSWvVNdCdxrth38nlySqJ2ickx6cmqM6+6Cqj+4DYL0CvgV2x6
    YXddn8jWwGH2mUajkWLGNt+8kTiZp731yCeWMKwace596i12DMLiajPLEUcdvkkf
    9ZXz+gtsCYuvBKOysEsa89/unkx4tsRb5KhmjTs/5bCW8Xq9PUxTGvCw0Xq3cR7N
    AeJxknkBWn9OQlWEgobTUN62epWu1VoJP/zu4SFs74zq1Zd95d95cBinuOAosc1J
    yvz0ozaYEOnMwPC17NYma5e60IZXjnSPPW/sYqH2CBe5azBkTGOsC+k7mMwaCyaW
    L9jq8wtbprzhzbmPJZ8CggEBAOUqw145Kbajov+nvRhZx0A1psrQqS78fxaR/71K
    TrOcYEgkJXbFHnIgLoeJjCH83Y1tsflGw89g5lI84kOXPbE33qAc8KCb3ivGBVg0
    EjKXD38zD6uAOdsImQArJL0Dh97LwtRZ98AAJz82lHY6SeproF8w5+1LiRR2rabI
    hkrh6zt3IyVq0LnTa7wPyzk/EmCX8K84WgfKm4G3C43ClJHKOj6Hn2fJJ8DL9qg0
    VWFM0ESxTYw6ok68JrNnimSl3d1ZSohUamqsBRvPflgfDiV5jHviZIgsneBfgKfU
    4fCcnnrc31fnFkje7DRDpkyYs965pQaD0TYBQs667Aovgl8CggEBAMc1v89Ox0Zr
    w9mgIj5VwDDEHiJOpZopiBIfGfspN/8bm28d4qCC8B75sbq90e0rxYP701bUb/T7
    ixtscWkPJxgv+mRPbfBr34ciuKaa5nWfki9y/Wkp/N50NLmd7b6WrvFICp+UeXnQ
    HlYtbySdZWFOsyaPDZeShdzgGDwty92JZLw85LbdfcNx+HyJ/P3yicCTtsM6/Ruy
    XLuazHyF6yqeEurq3WAlJNbUKL5kPnEw3yiNkNPV3C0VL/ckbfioYt/y4QZC7gFK
    KTlC4XhvSBh1EGzhzOZ+dp4FChSLJvuvd49p6PR+FlkX4KVE+B0khRZZ1ruMoBsg
    Mx4kjS47UE8CggEAXP/xsPc5umjF6UJFNvCYL7KWMZBkWDEX0i0Fv+e78J/xYtVo
    br6oEGCHAXIMcG6R6qctpp/VLv9/+LfEivGBk728lvWnoUYf71u5J4ZaLDWpkFFE
    drDeyci/bpYTnrEkHoJKWqr4I+7r/ndD4IbfIEb1Gixasq4Iv0k6R4jxFsqAD+3V
    UYX7lq359qPiMSUrbA+9GR6hSrAqU4XZJnpkmJWc9WtMgW3cuB0NyE0UqRvnGTlq
    4xGYdKNegUfvndDCLOXjnVfEp+2PVS3rdA+GSib9n/jMG4cfusKHD5UQ6/hjSDEC
    YkXhgUkWSk952XPO6wAjvHUaHfR9DDBHQgrtuQKCAQBv/XR+a9A1c6Hft1lo57Yq
    9CXorYQFnbGEVn25p9t2DCQenJNqHxI0p7TVwZ7BkWjxoOGXn8fs1njGivla0Yzt
    2RMPz2OD1HEOPGPILa6/k1yQVjnGJDenK3b0nqcoDPf+ZryqJ8L+yxQy6EniMKXs
    xVyLocJHYrTkjgqx0iEYwwOhmy4M64mnFWxXPw++B9qPK7uEF6ZxKp1dTlIE8xhY
    lhMWg8C+K0OBjjX1is9bvNjHqIYxwLmNkqqraox0TN2A/r6oUXoRuYphSYsNtKm4
    Lh90xp/1OEUg4r5e/DeHKIazVhwDTtrrbTP6VUKSx5QWE51XRGBBv6FdIblIs0mb
    AoIBAQC0R55KBPm47Yj8dxTYZ36tI9GtJNV8EsEeZT2l//3JQi2vbZ0E3pqMbLxN
    x+pNhHRE7BCVfdHED9HgFPqhEXiZqdY1t7Pv3utv9gDggGnv13Wzekn9gYrPfCcp
    vBcdd3dvCB5BHyOio++WKUZqO9KzSUhCJ6O2siyz+rdIS40xExiQNRWGWIqbcGl/
    GBD6zUN9UaKsCDgv7MMdClNtYsQqsxjqzklQv7Y5qOOMcBHaZIis6yieK/M+eBx7
    /xgM+/MU5s/3f8Yoc9teBzuRNWelELrKwFOAuedU1sYZVwD955yIiIc6yC3vCgTS
    B9MJsdJLTvgKtGS0AFDogUfDn2hp
    -----END PRIVATE KEY-----

[Back](Exercise_07_Secret_Containers.md) [Up](../README.md) [Next](Exercise_09_Flask_Application.md)
