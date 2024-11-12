# Create dynamodb table
resource "aws_dynamodb_table" "resume-table" {
  name           = "Resumes"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "first_one" {
  table_name = aws_dynamodb_table.resume-table.name
  hash_key   = aws_dynamodb_table.resume-table.hash_key

  item = <<ITEM
{
  "id": {
    "S": "1"
  },
  "basics": {
    "M": {
      "email": {
        "S": "shaunmane.sm@gmail.com"
      },
      "location": {
        "M": {
          "city": {
            "S": "Johannesburg"
          },
          "countryCode": {
            "S": "RSA"
          },
          "region": {
            "S": "Gauteng"
          }
        }
      },
      "name": {
        "S": "Shaun Mane"
      },
      "phone": {
        "S": "(+27)76 582-7899"
      },
      "profiles": {
        "L": [
          {
            "M": {
              "network": {
                "S": "Instagram"
              },
              "url": {
                "S": "https://www.instagram.com/mane_shaun/"
              },
              "username": {
                "S": "mane_shaun"
              }
            }
          },
          {
            "M": {
              "network": {
                "S": "LinkedIn"
              },
              "url": {
                "S": "https://www.linkedin.com/in/shaun-mane/"
              },
              "username": {
                "S": "Shaun Mane"
              }
            }
          },
          {
            "M": {
              "network": {
                "S": "GitHub"
              },
              "url": {
                "S": "https://github.com/shaunmane"
              },
              "username": {
                "S": "shaunmane"
              }
            }
          }
        ]
      },
      "summary": {
        "S": "A junior tech enthusiast with a foundation in Amazon Web Services (AWS). I am passionate about cloud computing and eager to grow my skills and knowledge in this dynamic field."
      },
      "url": {
        "S": "https://shaunmane.com"
      }
    }
  },
  "certificates": {
    "L": [
      {
        "M": {
          "date": {
            "S": "2024-02-15"
          },
          "issuer": {
            "S": "Amazon Web Services"
          },
          "name": {
            "S": "AWS Certified Solutions Architect Associate"
          },
          "url": {
            "S": "https://www.credly.com/badges/36441d01-5513-429a-b30c-7c40965e86b8/public_url"
          }
        }
      },
      {
        "M": {
          "date": {
            "S": "2024-02-10"
          },
          "issuer": {
            "S": "Amazon Web Services"
          },
          "name": {
            "S": "AWS Cloud Quest: Solutions Architect"
          },
          "url": {
            "S": "https://www.credly.com/badges/b411f2c8-3251-48d7-9390-1d6d4acfb752/public_url"
          }
        }
      },
      {
        "M": {
          "date": {
            "S": "2023-12-28"
          },
          "issuer": {
            "S": "Havard CS50"
          },
          "name": {
            "S": "CS50's Introduction to Programming with Python"
          },
          "url": {
            "S": "https://cs50.harvard.edu/certificates/517c9359-79d3-404d-9a5e-12274bb8f2db"
          }
        }
      },
      {
        "M": {
          "date": {
            "S": "2023-10-19"
          },
          "issuer": {
            "S": "Amazon Web Services"
          },
          "name": {
            "S": "AWS Certified Cloud Practitioner"
          },
          "url": {
            "S": "https://www.credly.com/badges/36441d01-5513-429a-b30c-7c40965e86b8/public_url"
          }
        }
      }
    ]
  },
  "education": {
    "L": [
      {
        "M": {
          "area": {
            "S": "AWS Cloud Computing"
          },
          "endDate": {
            "S": "2024-03-01"
          },
          "institution": {
            "S": "ALX Africa"
          },
          "startDate": {
            "S": "2023-02-01"
          },
          "studyType": {
            "S": "Programme"
          },
          "url": {
            "S": "https://www.alxafrica.com/about/"
          }
        }
      },
      {
        "M": {
          "area": {
            "S": "Construction Management"
          },
          "endDate": {
            "S": "2020-12-01"
          },
          "institution": {
            "S": "University of the Witwatersrand"
          },
          "startDate": {
            "S": "2020-02-01"
          },
          "studyType": {
            "S": "Honours"
          },
          "url": {
            "S": "https://www.wits.ac.za/"
          }
        }
      },
      {
        "M": {
          "area": {
            "S": "Construction Studies"
          },
          "endDate": {
            "S": "2018-11-30"
          },
          "institution": {
            "S": "University"
          },
          "startDate": {
            "S": "2014-02-01"
          },
          "studyType": {
            "S": "Bachelor"
          },
          "url": {
            "S": "https://uct.ac.za/"
          }
        }
      }
    ]
  },
  "interests": {
    "L": [
      {
        "M": {
          "keywords": {
            "L": [
              {
                "S": "Exposure"
              },
              {
                "S": "Composition"
              }
            ]
          },
          "name": {
            "S": "Photography"
          }
        }
      },
      {
        "M": {
          "keywords": {
            "L": [
              {
                "S": "No-gi"
              },
              {
                "S": "Position over submission"
              }
            ]
          },
          "name": {
            "S": "Brazilian Jiu-Jitsu"
          }
        }
      }
    ]
  },
  "languages": {
    "L": [
      {
        "M": {
          "fluency": {
            "S": "Native speaker"
          },
          "language": {
            "S": "English"
          }
        }
      }
    ]
  },
  "projects": {
    "L": [
      {
        "M": {
          "description": {
            "S": "Personal website hosted on AWS"
          },
          "endDate": {
            "S": ""
          },
          "highlights": {
            "S": ""
          },
          "name": {
            "S": "Cloud-Resume Challenge"
          },
          "startDate": {
            "S": ""
          },
          "url": {
            "S": "https://shaunmane.com/"
          }
        }
      }
    ]
  },
  "skills": {
    "L": [
      {
        "M": {
          "keywords": {
            "L": [
              {
                "S": "Cloud"
              },
              {
                "S": "Lambda"
              },
              {
                "S": "S3"
              },
              {
                "S": "CloudFront"
              }
            ]
          },
          "name": {
            "S": "AWS"
          }
        }
      },
      {
        "M": {
          "keywords": {
            "L": [
              {
                "S": "Cloud agnostic"
              },
              {
                "S": "IaC"
              },
              {
                "S": "HCL"
              }
            ]
          },
          "level": {
            "S": "Beginner"
          },
          "name": {
            "S": "Terraform"
          }
        }
      },
      {
        "M": {
          "keywords": {
            "L": [
              {
                "S": "Git"
              },
              {
                "S": "CI/CD"
              }
            ]
          },
          "level": {
            "S": "Beginner"
          },
          "name": {
            "S": "GitHub Actions"
          }
        }
      },
      {
        "M": {
          "keywords": {
            "L": [
              {
                "S": "Containers"
              }
            ]
          },
          "level": {
            "S": "Beginner"
          },
          "name": {
            "S": "Docker"
          }
        }
      }
    ]
  },
  "work": {
    "L": [
      {
        "M": {
          "endDate": {
            "S": "2024-10-31"
          },
          "name": {
            "S": "Enviro-Link"
          },
          "position": {
            "S": "Projects Administrator"
          },
          "startDate": {
            "S": "2023-04-01"
          }
        }
      }
    ]
  }
}
ITEM
}
