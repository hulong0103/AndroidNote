package com.example.apiservice.controller;

import com.example.apiservice.dto.ApiResponse;
import com.example.apiservice.dto.UserRequest;
import com.example.apiservice.model.User;
import com.example.apiservice.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/v1/users")
@Tag(name = "用户管理", description = "用户相关的API接口")
@CrossOrigin(origins = "*") // 允许跨域访问
public class UserController {
    
    @Autowired
    private UserService userService;
    
    @PostMapping
    @Operation(summary = "创建用户", description = "创建新用户")
    public ResponseEntity<ApiResponse<User>> createUser(@Valid @RequestBody UserRequest userRequest) {
        try {
            User user = userService.createUser(userRequest);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(ApiResponse.success("用户创建成功", user));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(e.getMessage()));
        }
    }
    
    @GetMapping
    @Operation(summary = "获取所有用户", description = "获取系统中所有用户列表")
    public ResponseEntity<ApiResponse<List<User>>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        return ResponseEntity.ok(ApiResponse.success("获取用户列表成功", users));
    }
    
    @GetMapping("/{id}")
    @Operation(summary = "根据ID获取用户", description = "根据用户ID获取用户详细信息")
    public ResponseEntity<ApiResponse<User>> getUserById(
            @Parameter(description = "用户ID") @PathVariable Long id) {
        Optional<User> user = userService.getUserById(id);
        if (user.isPresent()) {
            return ResponseEntity.ok(ApiResponse.success("获取用户成功", user.get()));
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error("用户不存在", 404));
        }
    }
    
    @GetMapping("/username/{username}")
    @Operation(summary = "根据用户名获取用户", description = "根据用户名获取用户详细信息")
    public ResponseEntity<ApiResponse<User>> getUserByUsername(
            @Parameter(description = "用户名") @PathVariable String username) {
        Optional<User> user = userService.getUserByUsername(username);
        if (user.isPresent()) {
            return ResponseEntity.ok(ApiResponse.success("获取用户成功", user.get()));
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error("用户不存在", 404));
        }
    }
    
    @GetMapping("/email/{email}")
    @Operation(summary = "根据邮箱获取用户", description = "根据邮箱获取用户详细信息")
    public ResponseEntity<ApiResponse<User>> getUserByEmail(
            @Parameter(description = "邮箱地址") @PathVariable String email) {
        Optional<User> user = userService.getUserByEmail(email);
        if (user.isPresent()) {
            return ResponseEntity.ok(ApiResponse.success("获取用户成功", user.get()));
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error("用户不存在", 404));
        }
    }
    
    @GetMapping("/search")
    @Operation(summary = "根据姓名搜索用户", description = "根据姓名模糊搜索用户")
    public ResponseEntity<ApiResponse<List<User>>> searchUsersByName(
            @Parameter(description = "姓名关键字") @RequestParam String name) {
        List<User> users = userService.searchUsersByName(name);
        return ResponseEntity.ok(ApiResponse.success("搜索用户成功", users));
    }
    
    @PutMapping("/{id}")
    @Operation(summary = "更新用户", description = "根据用户ID更新用户信息")
    public ResponseEntity<ApiResponse<User>> updateUser(
            @Parameter(description = "用户ID") @PathVariable Long id,
            @Valid @RequestBody UserRequest userRequest) {
        try {
            User user = userService.updateUser(id, userRequest);
            return ResponseEntity.ok(ApiResponse.success("用户更新成功", user));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(e.getMessage()));
        }
    }
    
    @DeleteMapping("/{id}")
    @Operation(summary = "删除用户", description = "根据用户ID删除用户")
    public ResponseEntity<ApiResponse<Void>> deleteUser(
            @Parameter(description = "用户ID") @PathVariable Long id) {
        try {
            userService.deleteUser(id);
            return ResponseEntity.ok(ApiResponse.success("用户删除成功", null));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(e.getMessage()));
        }
    }
    
    @GetMapping("/{id}/exists")
    @Operation(summary = "检查用户是否存在", description = "检查指定ID的用户是否存在")
    public ResponseEntity<ApiResponse<Boolean>> userExists(
            @Parameter(description = "用户ID") @PathVariable Long id) {
        boolean exists = userService.userExists(id);
        return ResponseEntity.ok(ApiResponse.success("检查完成", exists));
    }
}