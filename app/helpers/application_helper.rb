module ApplicationHelper
    def stripe_express_path
        "https://connect.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_GpuieyjzugppO4J3rxF0Yq5eMJ5hKWrW&scope=read_write"
    end
end
