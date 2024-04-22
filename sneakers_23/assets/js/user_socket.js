// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import { Socket } from "phoenix"

// And connect to the path in "lib/hello_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
export const productSocket = new Socket("/product_socket", { params: { token: window.userToken } })

