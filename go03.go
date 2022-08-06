package main

import (
  "time"
  "fmt"
  "strconv"
  "flag"
  "net/http"
  "github.com/gin-gonic/gin"
  "unicode"
  "os"
)

func cutCamelWithSpaces(s string) string {
    var result string
    runes := []rune(s)
    result = string(runes[0])
    for i:=1 ; i < len(runes); i++ {
       if unicode.IsUpper(runes[i]) {
	      result += " "
       }
       result += string(runes[i])
    }
    return result
}

func getEnv(env_name string) string {
  env_value := os.Getenv(env_name)
  if len(env_value) == 0  {
	  return "unknown"
  }
  return env_value
}

func customLogger(param gin.LogFormatterParams) string {
	return fmt.Sprintf("%s %d %s %s\n",
        param.TimeStamp.Format(time.RFC3339),
        param.StatusCode,
        param.Method,
        param.Path,
    )
  }


func setRoutes() *gin.Engine {
  gin.DisableConsoleColor()
  r := gin.New()
  r.Use(gin.LoggerWithFormatter(customLogger))
  r.Use(gin.Recovery())

  r.GET("/helloworld", func(c *gin.Context) {
    name := c.DefaultQuery("name", "Stranger")
    new_name := cutCamelWithSpaces(name)
    c.String(http.StatusOK, "Hello %s", new_name)
  })

  r.GET("/versionz", func(c *gin.Context) {
      c.JSON(http.StatusOK, gin.H{
      "github_hash" : getEnv("GITHUB_HASH"),
      "project_name" : getEnv("PROJECT_NAME"),
    })
  })

  // TODO append /probe/live /probe/ready route for healthcheck

  //  gin.DebugPrintRouteFunc = func(httpMethod, absolutePath, handlerName string, nuHandlers int) {
  //   log.Printf("endpoint %v %v %v %v\n", httpMethod, absolutePath, handlerName, nuHandlers)
  //   }

  return r
}

func main() {

  var port int
  flag.IntVar(&port, "port", -1, "port number (0-65535), overrides PORT env")
  flag.Parse()

  if port < 0  || port > 65535 {
     fmt.Println("invalid command line flag port value, or no flag port specified, fallback to default port")
  }

  r := setRoutes()
  if port != -1 {
	  r.Run(":" + strconv.Itoa(port))
  } else  {
     r.Run()
  }
}


