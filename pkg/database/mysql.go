package database

import (
	"fmt"
	"hellogrpc3/pkg/configs"

	_ "github.com/go-sql-driver/mysql" //go-lint
	"github.com/go-xorm/xorm"
	"xorm.io/core"
)

//DBEngine DBEngine
var DBEngine *xorm.Engine

func init() {
	var err error
	mysqlConf := configs.EnvConfig.Mysql
	dbURL := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", mysqlConf.User, mysqlConf.Pwd, mysqlConf.Host, mysqlConf.Port, mysqlConf.DBName)
	DBEngine, err = xorm.NewEngine("mysql", dbURL)
	tbMapper := core.NewPrefixMapper(core.GonicMapper{}, "t_")
	DBEngine.SetTableMapper(tbMapper)
	DBEngine.SetColumnMapper(core.GonicMapper{})
	DBEngine.ShowSQL(true)
	if err != nil {
		fmt.Printf("mysql init error:%s", err.Error())
	}
	err = DBEngine.Ping()
	if err != nil {
		fmt.Printf("mysql ping error:%s", err.Error())
	}
}
