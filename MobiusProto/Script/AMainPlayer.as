class AMainPlayer : APawn
{
    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxCollision;
    default BoxCollision.SetCollisionEnabled(ECollisionEnabled::QueryAndPhysics);
    default BoxCollision.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Block);

    UPROPERTY(DefaultComponent, Attach = BoxCollision)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent)
    UInputComponent InputComp;

    UPROPERTY()
    float MovementSpeed = 3000;

    UPROPERTY(DefaultComponent)
    UFloatingPawnMovement FloatingPawnMovement;
    default FloatingPawnMovement.MaxSpeed = MovementSpeed;
    default FloatingPawnMovement.Acceleration = MovementSpeed * 10;
    default FloatingPawnMovement.Deceleration = MovementSpeed * 10;


    UPROPERTY(DefaultComponent, Attach = BoxCollision)
    USpringArmComponent SpringArm;
    default SpringArm.TargetArmLength = 1250;  

    UPROPERTY(DefaultComponent, Attach = SpringArm)
    UCameraComponent MainCamera;



    UFUNCTION(BlueprintOverride)
    void ConstructionScript()
    {
        SpringArm.SetRelativeRotation(FRotator(-25, 0, 0));
    }

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        Print("Player is here", 5);
        PlayerInputSetup();
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds) 
    {

    }

    UFUNCTION()
    void PlayerInputSetup()
    {
        InputComp.BindAxis(n"MoveRight", FInputAxisHandlerDynamicSignature(this, n"MoveSides"));
    }

    UFUNCTION()
    void MoveSides(float AxisValue)
    {
        AddMovementInput(ControlRotation.RightVector, AxisValue * MovementSpeed, true);
        // Print("Axis Value = " + AxisValue, 1);
    }

} 