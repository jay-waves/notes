
## Day Count Convention

### Following Business Day & Modified Following

* `d-1` 向过去找一个工作日
* `d` 当天是不是工作日，如果不是则向后寻找
* `d+1` 向未来找一个工作日

需要引用 Holiday 表。第二个参数 `1` 表示 Saturday/Dunday weekend

```excel
    f=WORKDAY(d-1,1,Holiday...)
```

Modified Following:

```excel
    IF(MONTH(f)=MONTH(d),f,WORKDAY(d+1,-1,Holiday...))
```

### End-End Role (EOM)

`fpdate`: First Payment Date. 这里 End-of-Month 是指最后一个 Business Day，而不是自然月末

```excel
    IF(
        fpdate=WORKDAY(
            EOMONTH(fpdate,0)+1,-1,Holiday!$A$1:$A$277
        ),
        EOMONTH(EOMONTH(fpdate,0),A32),
        EDATE(fpdate,A32)
    ),
```
