package controller

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"x-ui/logger"
	"x-ui/web/service"
	"x-ui/web/session"
)

type LoginForm struct {
	Username string `json:"username" form:"username"`
	Password string `json:"password" form:"password"`
}

type IndexController struct {
	BaseController

	userService service.UserService
}

func NewIndexController(g *gin.RouterGroup) *IndexController {
	a := &IndexController{}
	a.initRouter(g)
	return a
}

func (a *IndexController) initRouter(g *gin.RouterGroup) {
	g.GET("/", a.index)
	g.POST("/login", a.login)
	g.GET("/logout", a.logout)
}

func (a *IndexController) index(c *gin.Context) {
	if session.IsLogin(c) {
		c.Redirect(http.StatusTemporaryRedirect, "xui/")
		return
	}
	html(c, "login.html", "X-UI Log in", nil)
}

func (a *IndexController) login(c *gin.Context) {
	var form LoginForm
	err := c.ShouldBind(&form)
	if err != nil {
		pureJsonMsg(c, false, "data format error")
		return
	}
	if form.Username == "" {
		pureJsonMsg(c, false, "please enter username")
		return
	}
	if form.Password == "" {
		pureJsonMsg(c, false, "Please enter password")
		return
	}
	user := a.userService.CheckUser(form.Username, form.Password)
	if user == nil {
		logger.Infof("wrong username or password: \"%s\" \"%s\"", form.Username, form.Password)
		pureJsonMsg(c, false, "wrong username or password")
		return
	}

	err = session.SetLoginUser(c, user)
	logger.Info("user", user.Id, "login success")
	jsonMsg(c, "WELCOME", err)
}

func (a *IndexController) logout(c *gin.Context) {
	user := session.GetLoginUser(c)
	if user != nil {
		logger.Info("user", user.Id, "logout")
	}
	session.ClearSession(c)
	c.Redirect(http.StatusTemporaryRedirect, c.GetString("base_path"))
}
