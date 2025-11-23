# setting variables for the project

variable "tags" {
    type = map(string)
    default = {
        Environment = "production"
        Project     = "workshop-devops-na-nuvem"
    }
}


variable "assume_role" {
    type = object({
        arn    = string
        region = string
    })
    default = {
        arn    = "arn:aws:iam::729780141482:role/workshop-devops-nuvem"
        region = "us-east-1"
    }
}