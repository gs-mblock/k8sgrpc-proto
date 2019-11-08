package model

//BaseModel BaseModel
type BaseModel struct {
	ID         int64 `json:"id" xorm:"pk notnull"`
	CreateBy   int   `json:"createBy"`
	CreateTime int   `json:"createTime" xorm:"created"`
	UpdateBy   int   `json:"updateBy"`
	UpdateTime int   `json:"updateTime" xorm:"updated"`
	DelFlag    int   `json:"delFlag"`
}

//APIResponse APIResponse
type APIResponse struct {
	Code    int         `json:"code" binding:"required"`
	Data    interface{} `json:"data"`
	Message string      `json:"message"`
}

//PageResponseModel PageResponseModel
type PageResponseModel struct {
	List       interface{} `json:"list"`
	PageNumber int         `json:"pageNumber"`
	PageSize   int         `json:"pageSize"`
	TotalCount int         `json:"totalCount"`
	TotalPage  int         `json:"totalPage"`
}

//PageRequestModel PageRequestModel
type PageRequestModel struct {
	PageNumber int    `json:"pageNumber"`
	PageSize   int    `json:"pageSize"`
	Sort       string `json:"sort"`
	Order      string `json:"order"`
}
