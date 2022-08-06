package main

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestHelloWorldRouteNoParams(t *testing.T) {
	router := setRoutes()

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/helloworld", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "Hello Stranger", w.Body.String())
}

func TestHelloWorldRouteParams(t *testing.T) {
	router := setRoutes()

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/helloworld?name=CapNameX", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "Hello Cap Name X", w.Body.String())
}

func TestVersionzRouteParams(t *testing.T) {
	router := setRoutes()

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/versionz", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.JSONEq(t, `{"github_hash": "abcd", "project_name": "test123"}`, w.Body.String())
}

