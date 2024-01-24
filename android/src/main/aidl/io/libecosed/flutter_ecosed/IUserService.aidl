package io.libecosed.flutter_ecosed;

interface IUserService {
    void destroy() = 16777114; // Destroy method defined by Shizuku server
    void exit() = 1; // Exit method defined by user

    void poem() = 2;
}