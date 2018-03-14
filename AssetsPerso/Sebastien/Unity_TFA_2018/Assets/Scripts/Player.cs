using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    #region PrivateVariable
    private float horizontalMove;
    private float verticalMove;
    private float velocity;
    private float distanceCooldownTime = 0.0f;
    private float meleeCoolDownTime = 0.0f;
    private float currentMoveSpeed;

    private Quaternion previousRotation = Quaternion.identity;
    private Quaternion rotationMeleeWeapon;

    private Rigidbody rigidBody;

    private bool canJump = false;
    private bool wantJump = false;

    private Transform meleeWeaponSpawn;
    private Transform PlayerPosition;

    private Vector3 offset = new Vector3(1.5f, 0.0f, 0.0f);

    private static Player current;

    #endregion

    #region PublicVariable
    [Header("Mouvement")]
    public float MoveSpeed = 1.0f;
    [Range(1.0f, 6.0f)]
    public float JumpForce = 10.0f;
    public float SprintSpeed = 5f;
    [Range(0f, 1f)]
    public float RotationSmoothness = 0.5f;
    public float RotateSpeed = 10.0f;

    public ParticleSystem speedTrailParticle;

    [Header("Attack")]
    public float FireRate = 10.0f;
    public float AttackRate = 10.0f;
    
    public GameObject Bullet;
    public GameObject MeleeWeaponRef;
   
    [Header("Characters")]
    public GameObject ArjunaMesh;
    public GameObject ErwinMesh;
    public GameObject TanvirMesh;
    public GameObject AlishaMesh;
    public GameObject TypeAMesh;
    public GameObject MallikaMesh;
    

    public KeyCode Arjuna;
    public KeyCode Erwin;
    public KeyCode Tanvir;
    public KeyCode Alisha;
    public KeyCode TypeA;
    public KeyCode Mallika;

    public bool IsActive;
    public bool areInPoison;

    public static Player Current
    {
        get { return current; }
    }
    #endregion
    void Awake()
    {
        current = this;
        meleeWeaponSpawn = transform.Find("MeleeSpawner");
    }   

    public enum Characters
    {
        Arjuna,
        Erwin,
        Tanvir,
        Alisha,
        TypeA,
        Mallika
    }
    public Characters ActiveChar = Characters.Arjuna;

    void Start()
    {
        ArjunaMesh.SetActive(true);
        ErwinMesh.SetActive(true);
        TanvirMesh.SetActive(true);
        AlishaMesh.SetActive(true);
        TypeAMesh.SetActive(true);
        MallikaMesh.SetActive(true);
        rigidBody = GetComponent<Rigidbody>();
    }
    private void FixedUpdate()
    {
        Move();
    }
    void Update()
    {
        currentMoveSpeed = MoveSpeed;
        ArjunaMesh.transform.position = transform.position;
        ErwinMesh.transform.position = transform.position;
        TanvirMesh.transform.position = transform.position;
        AlishaMesh.transform.position = transform.position;
        TypeAMesh.transform.position = transform.position;
        MallikaMesh.transform.position = transform.position;

        #region specialMovement
        if(Input.GetKey(KeyCode.LeftShift))
        {
            currentMoveSpeed = SprintSpeed;
            speedTrailParticle.Play();
           
        }
        if (Input.GetButtonDown("Jump") && canJump)
        {
            wantJump = true;
        }
        #endregion
        #region Attack

        float horizontalFire = Input.GetAxis("Horizontal2");
        float verticalFire = Input.GetAxis("Vertical2");

        float intensity = Mathf.Sqrt(horizontalFire * horizontalFire + verticalFire * verticalFire);


        distanceCooldownTime -= Time.deltaTime;

        if (intensity > 0.5f)
        {
            Quaternion rotationFire = Quaternion.LookRotation(new Vector3(horizontalFire, 0.0f, verticalFire));
            if (distanceCooldownTime <= 0.0f)
            {
                Instantiate(Bullet, transform.localPosition, rotationFire);
                distanceCooldownTime = 1.0f / FireRate;
            }
        }

        rotationMeleeWeapon = Quaternion.LookRotation(new Vector3(0.0f, 90.0f, 0.0f));
        meleeCoolDownTime -= Time.deltaTime;
        if (Input.GetKeyDown(KeyCode.A) && meleeCoolDownTime <= 0.0f)
        {
            Instantiate(MeleeWeaponRef, meleeWeaponSpawn.position + offset, rotationMeleeWeapon);
            meleeCoolDownTime = 1.0f / AttackRate;
        }
        #endregion
        #region SelectionPerso
        if (Input.GetKey(Arjuna))
            ActiveChar = Characters.Arjuna;
        if (Input.GetKey(Erwin))
            ActiveChar = Characters.Erwin;
        if (Input.GetKey(Tanvir))
            ActiveChar = Characters.Tanvir;
        if (Input.GetKey(Alisha))
            ActiveChar = Characters.Alisha;
        if (Input.GetKey(TypeA))
            ActiveChar = Characters.TypeA;
        if (Input.GetKey(Mallika))
            ActiveChar = Characters.Mallika;

        switch (ActiveChar)
        {
            case Characters.Arjuna:
                ArjunaMesh.SetActive(true);
                ErwinMesh.SetActive(false);
                TanvirMesh.SetActive(false);
                AlishaMesh.SetActive(false);
                TypeAMesh.SetActive(false);
                MallikaMesh.SetActive(false);
                break;
            case Characters.Erwin:
                ArjunaMesh.SetActive(false);
                ErwinMesh.SetActive(true);
                TanvirMesh.SetActive(false);
                AlishaMesh.SetActive(false);
                TypeAMesh.SetActive(false);
                MallikaMesh.SetActive(false);
                break;
            case Characters.Tanvir:
                ArjunaMesh.SetActive(false);
                ErwinMesh.SetActive(false);
                TanvirMesh.SetActive(true);
                AlishaMesh.SetActive(false);
                TypeAMesh.SetActive(false);
                MallikaMesh.SetActive(false);
                break;
            case Characters.Alisha:
                ArjunaMesh.SetActive(false);
                ErwinMesh.SetActive(false);
                TanvirMesh.SetActive(false);
                AlishaMesh.SetActive(true);
                TypeAMesh.SetActive(false);
                MallikaMesh.SetActive(false);
                break;
            case Characters.TypeA:
                ArjunaMesh.SetActive(false);
                ErwinMesh.SetActive(false);
                TanvirMesh.SetActive(false);
                AlishaMesh.SetActive(false);
                TypeAMesh.SetActive(true);
                MallikaMesh.SetActive(false);
                break;
            case Characters.Mallika:
                ArjunaMesh.SetActive(false);
                ErwinMesh.SetActive(false);
                TanvirMesh.SetActive(false);
                AlishaMesh.SetActive(false);
                TypeAMesh.SetActive(false);
                MallikaMesh.SetActive(true);
                break;
            default:
                break;
        }
        #endregion

        if(areInPoison)
        {
            Debug.Log("You are in the poison !!! ");
        }
    }

    private void Move()
    {
        
        velocity = rigidBody.velocity.y;
        float horizontalMove = Input.GetAxis("Horizontal");
        float verticalMove = Input.GetAxis("Vertical");
        float length = Mathf.Sqrt(horizontalMove * horizontalMove +
            verticalMove * verticalMove);

        length = Mathf.Max(length, 1f);

        horizontalMove *= Time.deltaTime * currentMoveSpeed / length;
        verticalMove *= Time.deltaTime * currentMoveSpeed / length;

        Vector3 deltaPosition = new
        Vector3(horizontalMove, 0f, verticalMove);

        RaycastHit hitInfoH, hitInfoV;

        bool collisionH = Physics.SphereCast(transform.position, 0.5f,
                                Vector3.right * Mathf.Sign(deltaPosition.x), out hitInfoH,
                                Mathf.Abs(deltaPosition.x) + 0.5f, 1 << 14, QueryTriggerInteraction.Collide);
        bool collisionV = Physics.SphereCast(transform.position, 0.5f,
                                Vector3.forward * Mathf.Sign(deltaPosition.z), out hitInfoV,
                                Mathf.Abs(deltaPosition.z) + 0.5f, 1 << 14, QueryTriggerInteraction.Collide);

        if (collisionH)
        {
            deltaPosition.x = Mathf.Sign(deltaPosition.x) * (hitInfoH.distance - 0.5f);
        }
        if (collisionV)
        {
            deltaPosition.z = Mathf.Sign(deltaPosition.z) * (hitInfoV.distance - 0.5f);
        }


        Vector3 position = rigidBody.position +
            deltaPosition;

        if(wantJump)
        {
            rigidBody.velocity = new Vector3(0, JumpForce, 0);
            wantJump = false;
        }

        Quaternion rotation;
        if (deltaPosition.magnitude > 0.01f)
        {
            rotation = Quaternion.LookRotation(
                deltaPosition.normalized);
        }
        else
        {
            rotation = previousRotation;
        }

        rigidBody.MovePosition(position);
        rigidBody.MoveRotation(Quaternion.Slerp(
            rigidBody.rotation, rotation, RotationSmoothness));

        previousRotation = rigidBody.rotation;


    }

    #region triggerPlayerGround
    void OnTriggerEnter(Collider col)
    {
        if (col.gameObject.layer == LayerMask.NameToLayer("Ground"))
        {
            canJump = true;
        }
    }
    void OnTriggerExit(Collider col)
    {
        if (col.gameObject.layer == LayerMask.NameToLayer("Ground"))
        {
            canJump = false;
        }
    }
    #endregion
}

