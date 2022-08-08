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
	//assert.Equal(t, "x", w.Body.String())
	assert.JSONEq(t, `{"github_hash": "abcd", "project_name": "test123"}`, w.Body.String())
}

func TestInternalLiveRouteParams(t *testing.T) {
	router := setRoutes()

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/internal/live", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "", w.Body.String())
}

func TestInternalReadyRouteParams(t *testing.T) {
	router := setRoutes()

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/internal/ready", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "", w.Body.String())
}

func TestShutdownRouteParams(t *testing.T) {
	router := setRoutes()

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/internal/shutdown", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "", w.Body.String())
}

func TestShutdownStatusOnRouteParams(t *testing.T) {
	router := setRoutes()

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/internal/shutdown?status=on", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "", w.Body.String())
}

func TestShutdownStatusOfRouteParams(t *testing.T) {
	router := setRoutes()

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/internal/shutdown?status=off", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "", w.Body.String())
}


